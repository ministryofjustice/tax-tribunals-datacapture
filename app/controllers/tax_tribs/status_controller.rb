class TaxTribs::StatusController < ApplicationController
  respond_to :json

  def index
    respond_with(Status.check)
  end
end
