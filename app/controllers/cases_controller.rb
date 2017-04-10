class CasesController < ApplicationController
  before_action :check_tribunal_case_presence, :check_tribunal_case_status, only: [:create]

  def create
    @presenter = presenter_class.new(current_tribunal_case, format: :pdf)
    CaseCreator.new(current_tribunal_case).call

    generate_and_upload_pdf
    send_emails

    redirect_to confirmation_path
  end

  def destroy
    tribunal_case = TribunalCase.find(params[:id])
    tribunal_case.destroy

    # TODO: redirecting to the prototype portfolio for now, this might change later
    redirect_to saved_appeals_path
  end

  private

  def generate_and_upload_pdf
    CaseDetailsPdf.new(current_tribunal_case, self, @presenter).generate_and_upload
  end

  def send_emails
    NotifyMailer.taxpayer_case_confirmation(current_tribunal_case).deliver_later
    NotifyMailer.ftt_new_case_notification(current_tribunal_case).deliver_later if current_tribunal_case.case_reference.blank?
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
