# frozen_string_literal: true

# An episode of a TV show!
# Data is mostly from the movie database
class Episode < ApplicationRecord
  belongs_to :season
end
