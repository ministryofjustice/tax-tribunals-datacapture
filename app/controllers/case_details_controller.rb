class CaseDetailsController < ApplicationController
  respond_to :pdf

  def index
    raise 'No tribunal case in session' unless current_tribunal_case

    details_pdf = CaseDetailsPdf.new(current_tribunal_case, self)
    send_data details_pdf.generate, filename: details_pdf.filename, disposition: 'inline'
  end

  # TODO: quick and dirty temporary action for testing purposes while developing
  # :nocov:
  def test_upload
    raise 'No tribunal case in session' unless current_tribunal_case

    CaseDetailsPdf.new(current_tribunal_case, self).generate_and_upload
  end
  # :nocov:
end
