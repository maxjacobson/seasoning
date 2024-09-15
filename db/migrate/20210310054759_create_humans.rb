# Introduce the humans table -- users, basically
class CreateHumans < ActiveRecord::Migration[6.1]
  def change
    create_table :humans do |t|
      t.string :handle,
               null: false,
               comment: "The handle is the human's nickname, username, or whatever you want to call it"

      t.string :email,
               null: false,
               comment: "Their email. This is how they'll log in. No passwords. Just click a link in your email."

      t.timestamps
    end
  end
end
