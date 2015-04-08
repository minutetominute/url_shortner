class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :submitter_id, presence: true

  belongs_to :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :visitors, through: :visits, source: :visitor

  has_many :distinct_visitors,
    -> { distinct },
    through: :visits,
    source: :visitor

  def self.random_code
    begin
      url = SecureRandom.urlsafe_base64[0...16]
    end until !ShortenedUrl.exists?(short_url: url)

    url
  end

  def self.create_for_user_and_long_url!(user, long_url)
    user.submitted_urls.create!(long_url: long_url,
      short_url: ShortenedUrl.random_code)
  end

  def num_clicks
    visits.count
  end

  # TODO: Ask about SELECT DISTINCT COUNT(DISTINCT ...
  def num_uniques
    distinct_visitors.select(:user_id).count
  end

  def num_recent_uniques
    distinct_visitors
      .where("visits.created_at > ?", 10.minutes.ago)
      .select(:user_id)
      .count
  end
end
