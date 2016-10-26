class DecisionsController < ApplicationController
  def show
    @decision = params[:id]
  end
end
