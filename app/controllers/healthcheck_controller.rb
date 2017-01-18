class HealthcheckController < ApplicationController
  respond_to :json

  def index
    respond_with(Healthcheck.check.to_json)
  end
end
