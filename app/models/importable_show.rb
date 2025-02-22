# Takes TMDB search results and presents them for importing
class ImportableShow
  def initialize(result)
    @result = result
  end

  delegate :id, to: :result

  delegate :name, to: :result

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
