# frozen_string_literal: true

RemoveMyShow = lambda do |show, human|
  my_show = MyShow.find_by(human:, show:) or raise ArgumentError, "No relationship to destroy"
  my_show.destroy!
end
