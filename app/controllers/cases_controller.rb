class CasesController < ApplicationController
  # TODO: to be completed as part of another PR
  #before_action :check_tribunal_case_presence, :check_tribunal_case_status

  def create
    new_case = CaseCreator.new(current_tribunal_case).call

    result_url = if new_case.success?
                   generate_and_upload_pdf
                   confirmation_path
                 else
                   flash[:alert] = new_case.errors
                   check_answers_path
                 end

    redirect_to result_url
  end

  private

  def generate_and_upload_pdf
    tribunal_case = presenter_class.new(current_tribunal_case)
    CaseDetailsPdf.new(tribunal_case, self).generate_and_upload
  end

  # :nocov:
  def presenter_class
    raise 'implement in subclasses'
  end

  def check_answers_path
    raise 'implement in subclasses'
  end

  def confirmation_path
    raise 'implement in subclasses'
  end
  # :nocov:
end
