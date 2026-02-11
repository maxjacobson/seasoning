class CheckForNewSeasonsJob
  include SuckerPunch::Job

  def perform(my_show_id)
    my_show = MyShow.find(my_show_id)
    logger.info "Checking for new seasons for #{my_show.show.slug} for #{my_show.human.handle}"

    return unless my_show.check_for_new_seasons

    logger.info "Moved #{my_show.show.slug} to next up for #{my_show.human.handle}"
  end
end
