require "application_system_test_case"

# System tests for the available_same_day checkbox on the show page
class AvailableSameDayTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(handle: "donna", email: "donna@example.com")
    @magic_link = MagicLink.create!(email: @human.email)

    @show = Show.create!(
      title: "Top Chef",
      tmdb_tv_id: 59_659,
      slug: "top-chef"
    )

    @my_show = MyShow.create!(
      human: @human,
      show: @show,
      status: "currently_watching"
    )
  end

  test "checkbox is checked by default when show is added" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    checkbox = find("input[type='checkbox'][name='my_show[available_same_day]']")

    assert_predicate checkbox, :checked?
  end

  test "checkbox is visible with descriptive label" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    assert_content "Episodes available day they air"
  end

  test "unchecking saves the setting and shows confirmation" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    find("input[type='checkbox'][name='my_show[available_same_day]']").uncheck

    assert_content "Updated Top Chef"
    assert_not @my_show.reload.available_same_day
  end

  test "checking saves the setting and shows confirmation" do
    @my_show.update!(available_same_day: false)

    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    checkbox = find("input[type='checkbox'][name='my_show[available_same_day]']")

    assert_not_predicate checkbox, :checked?

    checkbox.check

    assert_content "Updated Top Chef"
    assert_predicate @my_show.reload, :available_same_day
  end

  test "setting persists across page reloads" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    find("input[type='checkbox'][name='my_show[available_same_day]']").uncheck

    assert_content "Updated Top Chef"

    visit show_path(@show.slug)

    checkbox = find("input[type='checkbox'][name='my_show[available_same_day]']")

    assert_not_predicate checkbox, :checked?
  end

  test "checkbox is not shown when show has not been added" do
    @my_show.destroy!

    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    assert_no_selector "input[type='checkbox'][name='my_show[available_same_day]']"
  end
end
