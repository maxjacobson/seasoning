CheckForNewSeasons = lambda do |my_show|
  if my_show.available_unwatched_content?
    my_show.status = "next_up"
    my_show.save!

    ReturningShowNotification.create_or_find_by!(
      human: my_show.human,
      show: my_show.show
    )

    true
  else
    false
  end
end
