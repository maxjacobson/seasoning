# Where a show can be watched (in the US, for now) and how: streaming, renting, buying, and so on
# Data comes from TMDB, which gets it from JustWatch
class ShowProvider < ApplicationRecord
  # N.B. we only store US watch data for now; see ROADMAP for possible improvements
  WATCH_REGION = "US"

  CATEGORIES = ["flatrate", "rent", "buy", "free", "ads"].freeze
  CATEGORY_LABELS = {
    "flatrate" => "Stream",
    "rent" => "Rent",
    "buy" => "Buy",
    "free" => "Free",
    "ads" => "Free (with ads)"
  }.freeze

  belongs_to :show
  belongs_to :provider

  validates :category, inclusion: { in: CATEGORIES }
end
