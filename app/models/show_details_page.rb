class ShowDetailsPage
  attr_reader :show, :current_human, :include_skipped

  delegate :slug, :title, to: :show

  def initialize(show:, current_human:, include_skipped:)
    @show = show
    @current_human = current_human
    @include_skipped = include_skipped
  end

  def added?
    my_show.present?
  end

  def seasons?
    show.seasons.length.positive?
  end

  def my_show
    return nil if current_human.blank?

    if defined?(@my_show)
      @my_show
    else
      @my_show = current_human.my_shows.find_by(show: show)
    end
  end

  def skipped_seasons?
    show.skipped_seasons_for?(current_human)
  end

  def seasons
    @seasons ||= show.seasons.includes(:episodes).order(season_number: :asc).reject { |season| skipped_season?(season) }
  end

  def tmdb_url
    "https://www.themoviedb.org/tv/#{show.tmdb_tv_id}"
  end

  def watched_percentage
    return @watched_percentage if defined?(@watched_percentage)

    @watched_percentage = my_show.present? ? my_show.watched_percentage : 0
  end

  private

  def skipped_season?(season)
    return false if include_skipped
    return false unless added?

    my_show.skipped_season?(season)
  end
end
