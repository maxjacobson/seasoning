# A service a show can be watched on, like Netflix, AMC+, or Apple TV
# Data comes from TMDB, which gets it from JustWatch
class Provider < ApplicationRecord
  has_many :show_providers, dependent: :destroy
  has_many :shows, through: :show_providers

  def logo
    ProviderLogo.new(tmdb_logo_path)
  end
end
