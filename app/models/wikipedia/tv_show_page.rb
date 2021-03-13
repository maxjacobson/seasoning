# frozen_string_literal: true

module Wikipedia
  # Helps look up info about TV shows from wikipedia
  class TVShowPage
    InvalidURLError = Class.new(WikipediaError)
    RequestFailed = Class.new(WikipediaError)
    NotFound = Class.new(WikipediaError)

    API_ENDPOINT = "https://en.wikipedia.org/w/api.php"

    def initialize(url)
      @url = PageURL.new(url)
      raise InvalidURLError, @url.errors.full_messages.to_sentence unless @url.valid?
    end

    def title
      wikipedia_page.fetch("parse").fetch("title").gsub(/ \(TV series\)$/i, "")
    end

    def page_id
      wikipedia_page.fetch("parse").fetch("pageid")
    end

    private

    attr_reader :url

    def wikipedia_page
      return @wikipedia_page if defined?(@wikipedia_page)

      params = {
        "action" => "parse",
        "page" => url.title,
        "format" => "json"
      }
      uri = URI(API_ENDPOINT)
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(uri)

      raise RequestFailed, url unless response.code == "200"

      data = JSON.parse(response.body)
      raise NotFound, data.fetch("error").fetch("info") if data.key?("error")

      @wikipedia_page = data

      if @wikipedia_page.fetch("parse").fetch("templates").any? do |template|
           template.fetch("*") == "Template:Infobox television"
         end
        @wikipedia_page
      else
        raise NotFound, "Does not appear to be a television series"
      end

      @wikipedia_page
    end
  end
end
