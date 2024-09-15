# Generates an absolute URL for an episode still, based on the instructions here:
# https://developers.themoviedb.org/3/getting-started/images
class Still
  PREFERRED_SIZE = "w300"
  MissingConfiguration = Class.new(StandardError)
  MissingSizes = Class.new(StandardError)

  def initialize(still_path)
    @still_path = still_path
  end

  def url
    return nil if still_path.blank?

    format(
      "%<base>s%<size>s%<path>s",
      {
        base: config.secure_base_url,
        size: still_size,
        path: still_path
      }
    )
  end

  private

  attr_reader :still_path

  def still_size
    if config.still_sizes.include?(PREFERRED_SIZE)
      PREFERRED_SIZE
    else
      config.still_sizes.third || config.still_size.last || (raise MissingSizes)
    end
  end

  def config
    @config ||= TMDBAPIConfiguration.only || (raise MissingConfiguration)
  end
end
