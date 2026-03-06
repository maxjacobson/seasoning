CheckForNewSeasons = lambda do |my_show|
  if my_show.available_unwatched_content?
    my_show.status = "next_up"
    my_show.save!

    if my_show.watched_episodes?
      ReturningShowNotification.create_or_find_by!(
        human: my_show.human,
        show: my_show.show
      )
    else
      DebutingShowNotification.create_or_find_by!(
        human: my_show.human,
        show: my_show.show
      )
    end

    true
  else
    false
  end
end
