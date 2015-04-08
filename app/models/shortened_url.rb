class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :submitter_id, presence: true


  def self.random_code
    url = SecureRandom.urlsafe_base64[0...16]
    raise if ShortenedUrl.exists?(short_url: url)
    url
  rescue
    retry
  end


  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(submitter_id: user.id,
    long_url: long_url, short_url: ShortenedUrl.random_code)
  end


end