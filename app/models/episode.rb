# An episode of a TV show!
# Data is mostly from the movie database
class Episode < ApplicationRecord
  belongs_to :season

  def still
    Still.new(still_path)
  end

  def available?(human)
    return false if air_date.blank?

    air_date <= human.time_zone.today
  end
end
