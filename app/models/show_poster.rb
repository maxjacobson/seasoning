# frozen_string_literal: true

# Generates an absolute URL for a show poster, based on the instructions here:
# https://developers.themoviedb.org/3/getting-started/images
class ShowPoster
  PREFERRED_SIZE = "w185"
  MissingConfiguration = Class.new(StandardError)
  MissingSizes = Class.new(StandardError)

  def initialize(show)
    @show = show
  end

  def url
    return nil if show.tmdb_poster_path.blank?

    format(
      "%<base>s%<size>s%<path>s",
      {
        base: config.secure_base_url,
        size: poster_size,
        path: show.tmdb_poster_path
      }
    )
  end

  private

  attr_reader :show

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
