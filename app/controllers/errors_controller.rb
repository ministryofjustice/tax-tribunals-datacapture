class ErrorsController < ApplicationController
  def case_not_found
    respond_to do |format|
      format.html
      format.json { head :not_found }
    end
  end

  def case_submitted
    respond_to do |format|
      format.html
      format.json { head :unprocessable_entity }
    end
  end

  def unhandled
    respond_to do |format|
      format.html
      format.json { head :internal_server_error }
    end
  end
end
