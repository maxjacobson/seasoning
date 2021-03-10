# frozen_string_literal: true

class MyShow < ApplicationRecord
  belongs_to :human
  belongs_to :show
end
