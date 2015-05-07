class TagTopic < ActiveRecord::Base
  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :tag_topic_id,
    primary_key: :id
  )

  has_many(
    :shortened_urls,
    through: :taggings,
    source: :shortened_url
  )

  validates :topic, presence: true, uniqueness: true

  def self.topic_names
    self.all.pluck(:topic)
  end

  def most_popular_links
    shortened_urls
      .joins('JOIN visits ON shortened_urls.id = visits.shortened_url_id')
      .group('"shortened_url"')
      .order('COUNT(*) DESC')
  end
end
