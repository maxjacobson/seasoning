class ProgressiveWebAppController < ApplicationController
  def manifest
    authorize! { true }
    render layout: false, content_type: "application/manifest+json"
  end

  def service_worker
    authorize! { true }
    render layout: false, content_type: "application/javascript"
  end
end
