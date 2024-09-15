# Generates an absolute URL for a show poster, based on the instructions here:
# https://developers.themoviedb.org/3/getting-started/images
class Poster
  PREFERRED_SIZE = "w185"
  MissingConfiguration = Class.new(StandardError)
  MissingSizes = Class.new(StandardError)

  def initialize(poster_path)
    @poster_path = poster_path
  end

  def url
    return nil if poster_path.blank?

    format(
      "%<base>s%<size>s%<path>s",
      {
        base: config.secure_base_url,
        size: poster_size,
        path: poster_path
      }
    )
  end

  private

  attr_reader :poster_path

  def poster_size
    if config.poster_sizes.include?(PREFERRED_SIZE)
      PREFERRED_SIZE
    else
      config.poster_sizes.third || config.poster_size.last || (raise MissingSizes)
    end
  end

  def config
    @config ||= TMDBAPIConfiguration.only || (raise MissingConfiguration)
  end
end
