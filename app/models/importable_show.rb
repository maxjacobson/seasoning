# Takes TMDB search results and presents them for importing
class ImportableShow
  def self.from(tmdb_results)
    tmdb_ids = tmdb_results.map(&:id)
    existing_shows = Show.where(tmdb_tv_id: tmdb_ids).index_by(&:tmdb_tv_id)

    tmdb_results.map do |tmdb_result|
      new(tmdb_result, existing_shows[tmdb_result.id])
    end
  end

  def initialize(result, already_imported_show = nil)
    @result = result
    @already_imported_show = already_imported_show
  end

  delegate :id, to: :result

  delegate :name, to: :result

  attr_reader :already_imported_show

  def poster_url
    Poster.new(result.poster_path).url
  end

  def year
    return if result.first_air_date.blank?

    Date.parse(result.first_air_date).year
  end

  private

  attr_reader :result
end
