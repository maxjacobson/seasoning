# frozen_string_literal: true

# Base class for all controllers
class ApplicationController < ActionController::Base
  private

  def token
    request.headers["X-OIVA-TOKEN"]
  end
end
