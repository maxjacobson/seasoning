# frozen_string_literal: true

class Show < ApplicationRecord
  before_create -> { self.slug = title&.parameterize }
end
