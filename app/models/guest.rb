# frozen_string_literal: true

# Someone who is visiting the site
class Guest
  def authenticated
    true
  end

  def name
    "Max"
  end
end
