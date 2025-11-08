# Shows show search results
class SearchesController < ApplicationController
  def show
    authorize! { current_human.present? }

    query = params[:q].to_s.strip.presence
    return unless query

    if params[:tmdb] == "1"
      # Human explicitly requested TMDB results
      @tmdb_results = search_tmdb(query)
    else
      # First search the database
      @database_results = Show.where("lower(title) ilike lower(?)", "%#{query}%")

      if @database_results.any?
        @query = query
      else
        # No database results, search TMDB
        @tmdb_results = search_tmdb(query)
      end
    end
  end

  private

  def search_tmdb(query)
    tmdb_results = TMDB::Client.new.search_tv(query).results
    ImportableShow.from(tmdb_results)
  end
end
