# Generates an absolute URL for a watch provider logo, based on the instructions here:
# https://developers.themoviedb.org/3/getting-started/images
class ProviderLogo
  PREFERRED_SIZE = "w154"
  MissingConfiguration = Class.new(StandardError)

  def initialize(logo_path)
    @logo_path = logo_path
  end

  def url
    return nil if logo_path.blank?

    format(
      "%<base>s%<size>s%<path>s",
      {
        base: config.secure_base_url,
        size: logo_size,
        path: logo_path
      }
    )
  end

  private

  attr_reader :logo_path

  def logo_size
    if config.logo_sizes.include?(PREFERRED_SIZE)
      PREFERRED_SIZE
    else
      # N.B. the stored config may predate the logo_sizes column, in which case any width beats nothing
      config.logo_sizes.detect { |size| size.start_with?("w") } || PREFERRED_SIZE
    end
  end

  def config
    @config ||= TMDBAPIConfiguration.only || (raise MissingConfiguration)
  end
end
