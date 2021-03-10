# frozen_string_literal: true

# Someone who is visiting the site, who may or may not be an authenticated human
class Guest
  def self.from(token)
    session = BrowserSession
              .includes(:human)
              .where(token: token)
              .where("expires_at > now()")
              .first

    new(session&.human)
  end

  attr_reader :human

  def initialize(human)
    @human = human
  end

  def authenticated
    human.present?
  end
end
