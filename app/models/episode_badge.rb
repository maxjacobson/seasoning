class EpisodeBadge
  attr_reader :available, :upcoming

  def initialize(available, upcoming)
    @available = available
    @upcoming = upcoming
  end
end
