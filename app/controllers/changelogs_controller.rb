# Tell the story of how we got here
class ChangelogsController < ApplicationController
  def show
    authorize! { true }
  end
end
