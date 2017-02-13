module Steps::Details
  class CheckAnswersController < Steps::DetailsStepController
    respond_to :html, :pdf

    def show
      raise 'No tribunal case in session' unless current_tribunal_case

      @tribunal_case = AppealPresenter.new(current_tribunal_case)

      respond_to do |format|
        format.html
        format.pdf { download_case_pdf(@tribunal_case) and return }
      end
    end

    private

    def download_case_pdf(tribunal_case)
      pdf = CaseDetailsPdf.new(tribunal_case, self)
      send_data pdf.generate, filename: pdf.filename, type: 'application/pdf', disposition: 'inline'
    end

    def update_navigation_stack
      current_tribunal_case&.update(navigation_stack: [])
    end
  end
end
