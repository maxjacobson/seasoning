# frozen_string_literal: true

# Boots up the react app, which handles routing on the client side
class FrontendController < ApplicationController
  def show
    authorize! { true }
  end
end
