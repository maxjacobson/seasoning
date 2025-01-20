# Whenever someone logs in, we'll create one of these.
# It'll have a token we can stash in localstorage.
# Then we can figure out which human they are.
# If it's old we can consider it expired and log them out.
#
#
# FIXME - drop this table
class BrowserSession < ApplicationRecord
  belongs_to :human
  before_create -> { self.token = SecureRandom.uuid }
  before_create -> { self.expires_at = 3.months.from_now }

  scope :active, -> { where("expires_at > now()") }
  scope :inactive, -> { where("expires_at < now()") }
end
