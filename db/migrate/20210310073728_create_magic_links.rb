# let's have a table for magic links, which people can use to log in and sign up
class CreateMagicLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :magic_links do |t|
      t.string :email,
               null: false,
               comment: <<~COMMENT.squish
                 The email address that the magic link is sent to.
                 Following the link proves they are this human.
               COMMENT

      t.string :token,
               null: false,
               comment: "The thing that makes this link unique, which will be part of the link"

      t.timestamp :expires_at,
                  null: false,
                  comment: "When the magic link stops working"

      t.timestamps
    end

    add_index :magic_links, [:token], unique: true
  end
end
