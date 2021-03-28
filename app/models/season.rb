# frozen_string_literal: true

class Season < ApplicationRecord
  belongs_to :show
  before_create -> { self.slug = name&.gsub(/[^a-z0-9\s]/i, "")&.parameterize }
end
