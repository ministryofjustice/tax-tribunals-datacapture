class CasesController < ApplicationController
  before_action :check_tribunal_case_presence, :check_tribunal_case_status, only: [:create]
  before_action :authenticate_user!, except: [:create]

  def create
    @presenter = presenter_class.new(current_tribunal_case, format: :pdf)
    CaseCreator.new(current_tribunal_case).call

    generate_and_upload_pdf
    send_emails

    redirect_to confirmation_path
  end

  def destroy
    tribunal_case = current_user.tribunal_cases.find(params[:id])
    tribunal_case.destroy

    redirect_to cases_path
  end

  def resume
    tribunal_case = current_user.pending_tribunal_cases.find(params[:case_id])
    session[:tribunal_case_id] = tribunal_case.id

    redirect_to check_your_answers_path_for(tribunal_case)
  end

  def index
    @tribunal_cases = current_user.pending_tribunal_cases
  end

  private

  def generate_and_upload_pdf
    CaseDetailsPdf.new(current_tribunal_case, self, @presenter).generate_and_upload
  end

  def send_emails
    NotifyMailer.taxpayer_case_confirmation(current_tribunal_case).deliver_later
    NotifyMailer.ftt_new_case_notification(current_tribunal_case).deliver_later if current_tribunal_case.case_reference.blank?
  end

  def check_your_answers_path_for(tribunal_case)
    if tribunal_case.intent.eql?(Intent::TAX_APPEAL)
      steps_details_check_answers_path
    else
      steps_closure_check_answers_path
    end
  end

  # :nocov:
  def presenter_class
    raise 'implement in subclasses'
  end

  def confirmation_path
    raise 'implement in subclasses'
  end
  # :nocov:
end
