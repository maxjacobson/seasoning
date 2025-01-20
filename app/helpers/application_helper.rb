module ApplicationHelper
  def my_show_status(my_show)
    my_show.status.humanize
  end

  def path_for_review(review)
    # FIXME: translate to ruby
                # <Link
                #   to={`/${guest.human.handle}/shows/${yourSeason.show.slug}/${
                #     yourSeason.season.slug
                #   }${review.viewing === 1 ? "" : `/${review.viewing}`}`}
                # >

    raise
  end
end
