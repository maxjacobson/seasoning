# frozen_string_literal: true

class MyShow < ApplicationRecord
  belongs_to :human
  belongs_to :show
  enum status: {
    might_watch: "might_watch",
    currently_watching: "currently_watching",
    stopped_watching: "stopped_watching",
    waiting_for_more: "waiting_for_more",
    finished: "finished"
  }
end
