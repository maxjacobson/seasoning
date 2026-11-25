require "application_system_test_case"

# System tests for the availability_offset number input on the show page
class AvailabilityOffsetTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(handle: "donna", email: "donna@example.com")
    @magic_link = MagicLink.create!(email: @human.email)

    @show = Show.create!(title: "Top Chef", tmdb_tv_id: 59_659, slug: "top-chef")

    @my_show = MyShow.create!(human: @human, show: @show, status: "currently_watching")
  end

  test "number input shows 0 by default when show is added" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    input = find_field(type: "number", name: "my_show[availability_offset]")

    assert_equal "0", input.value
  end

  test "number input has min and max attributes" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    input = find_field(type: "number", name: "my_show[availability_offset]")

    assert_equal "-3", input["min"]
    assert_equal "3", input["max"]
  end

  test "input is visible with descriptive label" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    assert_content "New episodes are available to me this many days from air date"
    assert_content "0 means on the air date, negative means early, positive means later"
  end

  test "changing the offset saves the setting and shows confirmation" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    fill_in "my_show[availability_offset]", with: "3"
    find_field(type: "number", name: "my_show[availability_offset]").send_keys(:tab)

    assert_content "Updated Top Chef"
    assert_equal 3, @my_show.reload.availability_offset
  end

  test "negative offsets save the setting" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    fill_in "my_show[availability_offset]", with: "-2"
    find_field(type: "number", name: "my_show[availability_offset]").send_keys(:tab)

    assert_content "Updated Top Chef"
    assert_equal(-2, @my_show.reload.availability_offset)
  end

  test "setting persists across page reloads" do
    @my_show.update!(availability_offset: 3)

    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    input = find_field(type: "number", name: "my_show[availability_offset]")

    assert_equal "3", input.value
  end

  test "input is not shown when show has not been added" do
    @my_show.destroy!

    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    assert_no_selector "input[type='number'][name='my_show[availability_offset]']"
  end
end
