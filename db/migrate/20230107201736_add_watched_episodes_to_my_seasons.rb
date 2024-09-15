# Start tracking which episodes a person has watched
#
# I'm not super confident about this modeling. I might regret not introducing a
# `my_episodes` table, which could have some benefits:
#
# 1. db-enforced unique constraints
# 2. an obvious place to put more data, like episode reviews or timestamps about _when_
#    you watched the episode
#
# This should be sufficient for my current needs though, and those other ideas don't seem
# super compelling
class AddWatchedEpisodesToMySeasons < ActiveRecord::Migration[7.0]
  def change
    change_table :my_seasons do |t|
      t.integer :watched_episode_numbers,
                array: true,
                null: false,
                default: [],
                comment: "Which episodes has this person watched?"
    end
  end
end
