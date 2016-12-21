class CaseDetailsController < ApplicationController
  respond_to :pdf

  def index
    raise 'No tribunal case in session' unless current_tribunal_case

    send_data CaseDetailsPdf.new(current_tribunal_case, self).generate
  end

  # TODO: quick and dirty temporary action for testing purposes while developing
  def test_upload
    raise 'No tribunal case in session' unless current_tribunal_case

    CaseDetailsPdf.new(current_tribunal_case, self).generate_and_upload
  end
end
