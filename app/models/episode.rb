# frozen_string_literal: true

# An episode of a TV show!
# Data is mostly from the movie database
class Episode < ApplicationRecord
  belongs_to :season

  def still
    Still.new(still_path)
  end

  def available?
    air_date.present? && air_date <= Time.zone.today.end_of_day
  end
end
