# Someone who is visiting the site, who may or may not be an authenticated human
class Guest
  def self.from(human)
    new(human)
  end

  attr_reader :human

  def initialize(human)
    @human = human
  end

  def authenticated?
    human.present?
  end
end
