class User < ActiveRecord::Base
  has_many(
    :submitted_urls,
    class_name: 'ShortenedURL',
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :visitor_id,
    primary_key: :id
  )

  has_many(
    :visited_urls,
    proc { distinct },
    through: :visits,
    source: :shortened_url
  )

  validates :email, presence: true, uniqueness: true
end
