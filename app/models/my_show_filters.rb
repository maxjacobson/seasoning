# Helpers for the /shows page filters
class MyShowFilters
  include ActiveModel::Model
  include Rails.app.routes.url_helpers

  attr_writer :statuses
  attr_accessor :q, :page

  def statuses
    Array(@statuses).compact_blank.presence || ["currently_watching"]
  end

  def next_page_path
    params = { q:, statuses:, page: page + 1 }.compact
    shows_path(params)
  end

  def previous_page_path
    params = { q:, statuses:, page: page - 1 }.compact
    shows_path(params)
  end
end
