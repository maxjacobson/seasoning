# frozen_string_literal: true

# Let's forget we were gonna do this
class RemoveSpoilersConcept < ActiveRecord::Migration[6.1]
  def up
    remove_column :season_reviews, :spoilers
  end
end
