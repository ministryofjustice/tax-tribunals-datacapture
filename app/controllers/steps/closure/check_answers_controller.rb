module Steps::Closure
  class CheckAnswersController < Steps::ClosureStepController
    before_action :authenticate_user!, only: [:resume]

    def show
      @presenter = closure_presenter

      respond_to do |format|
        format.html
        format.pdf {
          summary = render_to_string "show.pdf.erb"
          render_pdf summary, filename: @presenter.pdf_filename
        }
      end
    end

    def resume
      @presenter = closure_presenter
    end

    private

    def render_pdf(html, filename:)
      pdf = Grover.new(html, format: 'A4').to_pdf
      send_data pdf, filename:, type: "application/pdf"
    end

    def closure_presenter
      CheckAnswers::ClosureAnswersPresenter.new(current_tribunal_case, format: request.format.symbol, locale: I18n.locale)
    end
  end
end
