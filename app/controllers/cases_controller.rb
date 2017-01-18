class CasesController < ApplicationController
  def create
    new_case = CaseCreator.new(current_tribunal_case).call

    result_url = if new_case.success?
                   generate_and_upload_pdf
                   new_case.payment_url
                 else
                   flash[:alert] = new_case.errors
                   steps_details_check_answers_path
                 end

    redirect_to result_url
  end

  private

  def generate_and_upload_pdf
    tribunal_case = CaseDetailsPresenter.new(current_tribunal_case)
    CaseDetailsPdf.new(tribunal_case, self).generate_and_upload
  end
end
