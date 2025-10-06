class ReturningShowNotification < ApplicationRecord
  belongs_to :human
  belongs_to :show

  validates :human_id, uniqueness: { scope: :show_id }
end
