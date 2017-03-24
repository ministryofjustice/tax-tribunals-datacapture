class StatusController < ApplicationController
  respond_to :json

  def index
    respond_with(Status.check.to_json)
  end
end
