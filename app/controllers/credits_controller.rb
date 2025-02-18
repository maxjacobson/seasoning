# Give some shout outs to the hard work that went into this website
class CreditsController < ApplicationController
  def show
    authorize! { true }
  end
end
