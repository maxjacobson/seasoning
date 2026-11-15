# How a human feels about a watch provider: they can pin it (so it is surfaced on show pages)
# or hide it (so it stops showing up on the where-to-watch page)
class ProviderPreference < ApplicationRecord
  STATUSES = ["pinned", "hidden"].freeze

  enum :status, { pinned: "pinned", hidden: "hidden" }

  belongs_to :human
  belongs_to :provider
end
