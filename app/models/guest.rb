# frozen_string_literal: true

# Someone who is visiting the site, who may or may not be an authenticated human
class Guest
  def self.from(token)
    session = BrowserSession
              .includes(:human)
              .where(token: token)
              .active
              .first

    new(session&.human, token)
  end

  attr_reader :human, :token

  def initialize(human, token)
    @human = human
    @token = token
  end

  def authenticated
    human.present?
  end
end
