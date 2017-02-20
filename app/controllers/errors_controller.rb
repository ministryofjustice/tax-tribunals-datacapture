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
end
