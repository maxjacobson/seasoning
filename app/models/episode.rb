# An episode of a TV show!
# Data is mostly from the movie database
class Episode < ApplicationRecord
  belongs_to :season

  def still
    Still.new(still_path)
  end

  def available?(time_zone = Time.zone, available_same_day: true)
    return false if air_date.blank?

    effective_today = available_same_day ? time_zone.today : time_zone.yesterday
    air_date <= effective_today
  end
end
