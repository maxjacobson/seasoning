# Shows show search results
class SearchesController < ApplicationController
  def show
    authorize! { current_human.present? }

    @results = if (query = params[:q].to_s.strip.presence)
                 tmdb_results = TMDB::Client.new.search_tv(query).results
                 ImportableShow.from(tmdb_results)
               else
                 []
               end
  end
end
