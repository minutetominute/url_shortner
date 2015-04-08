class Visit < ActiveRecord::Base
  validates :user_id, presence: true
  validates :shortened_url_id, presence: true

  belongs_to :visitor,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  belongs_to :short_url,
    class_name: "ShortenedUrl",
    foreign_key: :shortened_url_id,
    primary_key: :id

  def self.record_visit!(user, shortened_url)
    user.visits.create!(short_url: shortened_url)
  end
end
