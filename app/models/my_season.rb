# frozen_string_literal: true

class MySeason < ApplicationRecord
  belongs_to :human
  belongs_to :season
end
