# Base class for all controllers
class ApplicationController < ActionController::Base
  protect_from_forgery using: :header_or_legacy_token

  before_action :redirect_apex_domain
  after_action :verify_authorization_occurred
  before_bugsnag_notify :add_human_info_to_bugsnag

  NotAuthorized = Class.new(StandardError)

  private

  def redirect_apex_domain
    return unless request.host == "seasoning.tv"

    redirect_to("#{request.protocol}www.seasoning.tv#{request.fullpath}", status: :found)
  end

  def authorize!
    raise NotAuthorized unless yield

    @did_authorize = true
  end

  def verify_authorization_occurred
    raise "Did not check authorization" unless @did_authorize
  end

  def current_human
    return @current_human if defined?(@current_human)

    @current_human = Human.find_by(id: session[:human_id])
  end

  helper_method :current_human

  def returning_show_notifications
    return [] if current_human.blank?

    @returning_show_notifications ||= current_human.returning_show_notifications.includes(:show)
  end

  helper_method :returning_show_notifications

  def add_human_info_to_bugsnag(event)
    return if current_human.blank?

    event.set_user(current_human.id.to_s, current_human.email, current_human.handle)
  end

  def current_page
    Integer(params[:page]).tap do |val|
      raise ArgumentError unless val >= 1
    end
  rescue TypeError, ArgumentError
    1
  end
  helper_method :current_page

  def proper_review_path(review)
    if review.viewing == 1
      profile_season_review_path(review.author.handle, review.season.show.slug, review.season.slug)
    else
      profile_season_review_viewing_path(
        review.author.handle,
        review.season.show.slug,
        review.season.slug,
        review.viewing
      )
    end
  end
  helper_method :proper_review_path
end
