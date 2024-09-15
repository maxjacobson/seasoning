# represents a show that someone is trying to add to the site
class ImportSerializer < Oj::Serializer
  attributes :id, :name
  serializer_attributes :poster_url, :year

  def poster_url
    Poster.new(import.poster_path).url
  end

  def year
    return if import.first_air_date.blank?

    Date.parse(import.first_air_date).year
  end
end
