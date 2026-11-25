# An episode of a TV show!
# Data is mostly from the movie database
class Episode < ApplicationRecord
  belongs_to :season

  def still
    Still.new(still_path)
  end

  def available?(time_zone = Time.zone, availability_offset: 0)
    return false if air_date.blank?

    effective_today = time_zone.today - availability_offset
    air_date <= effective_today
  end
end
