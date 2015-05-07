require 'securerandom'

class ShortenedURL < ActiveRecord::Base
  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many(
    :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor
  )

  validates_presence_of :long_url, :short_url, :submitter_id
  validates :long_url, length: {maximum: 1024}
  validate :prevent_too_many_submissions

  def self.num_submitted_by_user_in_last_minute(user)
    where('created_at > ? AND submitter_id = ?', 1.minute.ago, user.id).count
  end

  def self.random_code
    code = nil
    loop do
      code = SecureRandom.urlsafe_base64(16)
      break unless exists?(short_url: code)
    end

    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    create(
      long_url: long_url,
      submitter_id: user.id,
      short_url: random_code
    )
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visits
      .where('created_at > ?', 10.minutes.ago)
      .count
  end



  def prevent_too_many_submissions
    if 5 < self.class.num_submitted_by_user_in_last_minute(submitter)
      errors.add(:user, 'making too many submissions')
    end
  end
end
