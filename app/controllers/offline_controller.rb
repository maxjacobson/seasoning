class OfflineController < ApplicationController
  def show
    authorize! { true }
  end
end
