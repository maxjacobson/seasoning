class EpisodeBadge
  attr_reader :available, :upcoming

  def initialize(available, upcoming)
    @available = available
    @upcoming = upcoming
  end

  def any_available?
    available.positive?
  end
end
