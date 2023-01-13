# frozen_string_literal: true

# job to invoke the refresh show service asynchronously
# which is nice because if one show fails to refresh, that won't block all of the others
class RefreshShowJob
  include SuckerPunch::Job

  def perform(show_id)
    show = Show.find(show_id)
    logger.info "Refreshing show #{show.slug}"

    show.refresh!
  end
end
