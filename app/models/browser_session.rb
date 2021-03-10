# frozen_string_literal: true

# Whenever someone logs in, we'll create one of these.
# It'll have a token we can stash in localstorage.
# Then we can figure out which human they are.
# If it's old we can consider it expired and log them out.
class BrowserSession < ApplicationRecord
  belongs_to :human
end
