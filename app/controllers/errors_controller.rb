class ErrorsController < ApplicationController
  def case_submitted
    @tribunal_case = current_tribunal_case
    respond_with_status(:unprocessable_entity)
  end

  def case_not_found
    respond_with_status(:not_found)
  end

  def not_found
    respond_with_status(:not_found)
  end

  def invalid_session
    respond_with_status(:not_found)
  end

  def unhandled
    respond_with_status(:internal_server_error)
  end

  private

  def respond_with_status(status)
    respond_to do |format|
      format.html
      format.all { head status }
    end
  end
end
