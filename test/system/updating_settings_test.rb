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

    # Test default review visibility
    click_on "Settings"

    assert_equal "anybody", @human.default_review_visibility
    select "Myself", from: "Default review visibility"

    assert_content "Saved!"
    @human.reload

    assert_equal "myself", @human.default_review_visibility

    # Test currently watching limit
    visit current_path # Refresh page

    assert_nil @human.currently_watching_limit
    select "5", from: "Currently watching limit"

    assert_content "Saved!"
    @human.reload

    assert_equal 5, @human.currently_watching_limit

    # Test share currently watching
    visit current_path # Refresh page

    assert @human.share_currently_watching
    uncheck "Share currently watching"

    assert_content "Saved!"
    @human.reload

    assert_not @human.share_currently_watching

    # Test time zone
    visit current_path # Refresh page

    assert_equal "Eastern Time (US & Canada)", @human.time_zone_name
    select "Pacific Time (US & Canada)", from: "Time zone"

    assert_content "Saved!"
    @human.reload

    assert_equal "Pacific Time (US & Canada)", @human.time_zone_name
  end
end
