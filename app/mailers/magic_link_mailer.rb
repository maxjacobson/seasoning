# frozen_string_literal: true

# Delivers the magic links to let people join the site or log back in
class MagicLinkMailer < ApplicationMailer
  default from: "Seasoning <magic@seasoning.tv>"

  def welcome_email(recipient, token)
    @token = token

    mail(
      to: recipient,
      subject: "Welcome"
    )
  end

  def log_in_email(recipient, token)
    @token = token

    mail(
      to: recipient,
      subject: "Welcome back"
    )
  end
end
