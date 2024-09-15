# This is really important to me, to make this site useful
class AddNoteToSelfToMyShow < ActiveRecord::Migration[6.1]
  def change
    change_table :my_shows do |t|
      t.text :note_to_self,
             comment: <<~MSG.squish
               An optional blob of Markdown-formatted text that the human can write
               to remind themselves why they've added the show, or however they want
               to use it
             MSG
    end
  end
end
