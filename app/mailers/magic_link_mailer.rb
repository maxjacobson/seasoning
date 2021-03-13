# frozen_string_literal: true

# Delivers the magic links to let people join the site or log back in
class MagicLinkMailer < ApplicationMailer
  default from: "Seasoning <magic@mail.seasoning.tv>"

  def welcome_email(recipient, token)
    @token = token

    mail(
      to: recipient,
      subject: "Welcome to Seasoning!"
    )
  end

  def log_in_email(recipient, token)
    @token = token
    @greeting = [
      "Oh good, the commercials are over, come back in!",
      "Welcome back to Seasoning!"
    ].sample

    mail(
      to: recipient,
      subject: "Welcome back to Seasoning!"
    )
  end
end
