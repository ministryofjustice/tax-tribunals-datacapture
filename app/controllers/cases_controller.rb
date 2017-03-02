class CasesController < ApplicationController
  before_action :check_tribunal_case_presence, :check_tribunal_case_status

  def create
    CaseCreator.new(current_tribunal_case).call

    generate_and_upload_pdf
    send_emails

    redirect_to confirmation_path
  end

  private

  def generate_and_upload_pdf
    tribunal_case = presenter_class.new(current_tribunal_case)
    CaseDetailsPdf.new(tribunal_case, self).generate_and_upload
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
