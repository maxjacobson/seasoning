# frozen_string_literal: true

module API
  # This is how people sign up and sign in. There's no passwords. Only magic links.
  # If you have access to your email account, you're you.
  class MagicLinksController < ApplicationController
    def create
      email = params.require(:magic_link).require(:email)

      # This is a "loose" validation which I think is fine.
      # I won't actually create a human until someone follows the magic link, which proves that it
      # was a real email address.
      if EmailValidator.valid?(email)
        magic_link = MagicLink.create!(email: email)
        magic_link.deliver
        render json: MagicLinkSerializer.one(magic_link)
      else
        render json: {}, status: 400
      end
    end

    def show
      magic_link = MagicLink.where("expires_at > now()").find_by!(token: params[:id])
      human = Human.where(email: magic_link.email).first

      if human.present?
        browser_session = human.browser_sessions.create!
        render json: {
          already_exists: true,
          session_token: browser_session.token,
          email: human.email,
          handle: human.handle
        }
      else
        render json: {
          already_exists: false,
          email: magic_link.email
        }
      end
    end
  end
end
