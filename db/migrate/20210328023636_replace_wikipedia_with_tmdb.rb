# frozen_string_literal: true

# We're making the switch, baby
class ReplaceWikipediaWithTMDB < ActiveRecord::Migration[6.1]
  def change
    add_column :shows, :tmdb_tv_id, :integer, null: true

    reversible do |dir|
      dir.up do
        [
          [28, "Halt and Catch Fire", 59_659, "halt-and-catch-fire"],
          [16, "The Sopranos", 1398, "the-sopranos"],
          [27, "The Office", 2316, "the-office"],
          [26, "Ozark", 69_740, "ozark"],
          [25, "The Knick", 61_014, "the-knick"],
          [24, "How To with John Wilson", 110_971, "how-to-with-john-wilson"],
          [23, "Peaky Blinders", 60_574, "peaky-blinders"],
          [22, "His Dark Materials", 68_507, "his-dark-materials"],
          [21, "Teenage Bounty Hunters", 90_766, "teenage-bounty-hunters"],
          [20, "Doctor Foster", 63_913, "doctor-foster"],
          [19, "Dickinson", 89_901, "dickinson"],
          [18, "For All Mankind", 87_917, "for-all-mankind"],
          [17, "Terriers", 33_400, "terriers"],
          [15, "The Magicians", 64_432, "the-magicians"],
          [14, "Zoey's Extraordinary Playlist", 95_941, "zoeys-extraordinary-playlist"]
        ].each do |(show_id, title, tmdb_tv_id, slug)|
          Show.where(id: show_id).update_all(title: title, tmdb_tv_id: tmdb_tv_id, slug: slug)
        end
      end
    end
    change_column_null :shows, :tmdb_tv_id, false

    remove_column :shows, :wikipedia_page_id, :integer, null: false, default: -1
    remove_column :shows, :number_of_seasons, :integer, null: false, default: -1
  end
end
