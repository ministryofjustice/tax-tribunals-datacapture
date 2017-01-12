module Steps::Details
  class CheckAnswersController < Steps::DetailsStepController
    respond_to :html, :pdf

    def show
      raise 'No tribunal case in session' unless current_tribunal_case

      @tribunal_case = CaseDetailsPresenter.new(current_tribunal_case)

      respond_to do |format|
        format.html
        format.pdf {
          pdf = CaseDetailsPdf.new(@tribunal_case, self)
          send_data pdf.generate, filename: pdf.filename, disposition: 'inline'
        }
      end
    end
  end
end
