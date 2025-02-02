module API
  # Interactions with the human (aka user) resource
  class HumansController < ApplicationController
    def create
      authorize! { true }

      human_params = params.expect(humans: %i[magic_link_token handle])
      magic_link = MagicLink.active.find_by!(token: human_params[:magic_link_token])

      human = Human.create!(
        email: magic_link.email,
        handle: human_params[:handle]
      )
      browser_session = human.browser_sessions.create!
      render json: {
        already_exists: true,
        session_token: browser_session.token,
        email: human.email,
        handle: human.handle
      }
    end
  end
end
