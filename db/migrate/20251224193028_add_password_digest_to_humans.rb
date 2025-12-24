class AddPasswordDigestToHumans < ActiveRecord::Migration[8.2]
  def change
    add_column :humans, :password_digest, :string,
               null: true,
               comment: "Optional bcrypt password hash. Humans can use either magic links or passwords to authenticate."
  end
end
