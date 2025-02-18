# Some helper methods for views (if any!)
module ApplicationHelper
  def markdown_to_html(text)
    Kramdown::Document.new(text, input: "GFM").to_html
  end
end
