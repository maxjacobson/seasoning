# frozen_string_literal: true

# Base class for all controllers
class ApplicationController < ActionController::Base
  before_action :redirect_apex_domain
  after_action :verify_authorization_occurred

  private

  def redirect_apex_domain
    return unless request.host == "seasoning.tv"

    redirect_to("#{request.protocol}www.seasoning.tv#{request.fullpath}", status: 302)
  end

  def authorize!
    raise "Not authorized to do this" unless yield

    @did_authorize = true
  end

  def verify_authorization_occurred
    raise "Did not check authorization" unless @did_authorize
  end

  def token
    request.headers["X-SEASONING-TOKEN"]
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
