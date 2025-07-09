require "application_system_test_case"

# System test covering viewing and upating settings
class UpdatingSettingsTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "cam",
      email: "cam@example.com"
    )
    @magic_link = MagicLink.create!(email: @human.email)
  end

  test "updating settings" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Settings"

    assert_equal "anybody", @human.default_review_visibility
    assert_nil @human.currently_watching_limit
    assert @human.share_currently_watching

    select "Myself", from: "Default review visibility"
    select "5", from: "Currently watching limit"
    uncheck "Share currently watching"
    click_on "Update settings"

    assert_content "Saved!"

    @human.reload

    assert_equal "myself", @human.default_review_visibility
    assert_equal 5, @human.currently_watching_limit
    assert_not @human.share_currently_watching
  end
end
