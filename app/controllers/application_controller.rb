# frozen_string_literal: true

# Base class for all controllers
class ApplicationController < ActionController::Base
  after_action :verify_authorization_occurred

  private

  def authorize!
    raise "Not authorized to do this" unless yield

    @did_authorize = true
  end

  def verify_authorization_occurred
    raise "Did not check authorization" unless @did_authorize
  end

  def token
    request.headers["X-OIVA-TOKEN"]
  end

  def current_human
    return @current_human if defined?(@current_human)

    @current_human =
      begin
        if token.blank?
          nil
        else
          BrowserSession.active.includes(:human).where(token: token).first&.human
        end
      end
  end
end
