# Update db comment to reflect latest changes
class UpdateBrowserSessionComment < ActiveRecord::Migration[8.0]
  def change
    change_column_comment(
      :browser_sessions,
      :token,
      from: "The token that will be kept in localstorage and included with API requests",
      to: "A token that is kept in the session"
    )
  end
end
