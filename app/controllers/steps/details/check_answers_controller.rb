module Steps::Details
  class CheckAnswersController < Steps::DetailsStepController
    before_action :authenticate_user!, only: [:resume]

    def show
      @presenter = appeal_presenter

      respond_to do |format|
        format.html
        format.pdf { render @presenter.pdf_params }
        format.text

      end
    end

    def resume
      @presenter = appeal_presenter
    end

    private

    def appeal_presenter
      CheckAnswers::AppealAnswersPresenter.new(current_tribunal_case, format: request.format.symbol)
    end
  end
end
