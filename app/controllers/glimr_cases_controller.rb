class GlimrCasesController < ApplicationController
  before_action :check_tribunal_case_presence, :check_tribunal_case_status

  def create
    @presenter = presenter_class.new(current_tribunal_case, format: :pdf)
    TaxTribs::CaseCreator.new(current_tribunal_case).call

    generate_and_upload_pdf
    send_emails

    redirect_to confirmation_path
  end

  private

  def generate_and_upload_pdf
    TaxTribs::CaseDetailsPdf.new(current_tribunal_case, self, @presenter).generate_and_upload
  end

  def send_emails
    NotifyMailer.taxpayer_case_confirmation(current_tribunal_case).deliver_later
    NotifyMailer.ftt_new_case_notification(current_tribunal_case).deliver_later if current_tribunal_case.case_reference.blank?
    NotifyMailer.application_details_copy(current_tribunal_case, :taxpayer,
                                          case_to_string).deliver_later if current_tribunal_case.send_taxpayer_copy?
    NotifyMailer.application_details_copy(current_tribunal_case, :representative,
                                          case_to_string).deliver_later if current_tribunal_case.send_representative_copy?
  end

  def case_to_string
    @case_to_string ||= render_to_string(
      template: pdf_template,
      formats: [:text],
      encoding: 'UTF-8'
    )
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
