# frozen_string_literal: true

module Wikipedia
  # Humans can import a TV show by providing the link to the page on Wikipedia.
  # This class validates that it looks like it is good input, and peels out the "title"
  # part of the URL
  class PageURL
    include ActiveModel::Validations

    PATH_PATTERN = %r{/wiki/(.+)}

    validate :valid_uri
    validate :uses_https
    validate :english_wikipedia
    validate :looks_like_a_wikipedia_page

    def initialize(page_url)
      @page_url = page_url
    end

    def title
      CGI.unescape(page_uri.path.match(PATH_PATTERN).to_a.fetch(1))
    end

    private

    attr_reader :page_url

    def page_uri
      return @page_uri if defined?(@page_uri)

      @page_uri = begin
        URI(page_url)
      rescue URI::InvalidURIError
        nil
      end
    end

    def valid_uri
      errors.add(:base, "not a valid URL") if page_uri.blank?
    end

    def uses_https
      return if page_uri.blank?

      errors.add(:base, "must be an https URL") if page_uri.scheme != "https"
    end

    def english_wikipedia
      return if page_uri.blank?

      errors.add(:base, "must be an English Wikipedia page") unless page_uri.host.in?(
        ["en.wikipedia.org", "en.m.wikipedia.org"]
      )
    end

    def looks_like_a_wikipedia_page
      return if page_uri.blank?

      errors.add(:base, "must be a Wikipedia page") unless page_uri.path =~ PATH_PATTERN
    end
  end
end
