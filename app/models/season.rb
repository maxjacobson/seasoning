# A season of a TV show!
# Data is mostly from the movie database
class Season < ApplicationRecord
  belongs_to :show
  has_many :episodes, dependent: :destroy
  before_save -> { self.slug = name&.gsub(/[^a-z0-9\s]/i, "")&.parameterize }

  scope :aired_in, lambda { |year|
    where("EXTRACT(year FROM air_date) = ?", year)
  }

  def poster
    Poster.new(tmdb_poster_path.presence || show.tmdb_poster_path)
  end
end
