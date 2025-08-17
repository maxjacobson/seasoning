require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "markdown_to_html converts basic markdown" do
    text = "This is **bold** text"
    html = markdown_to_html(text)

    assert_includes html, "<strong>bold</strong>"
  end
end
