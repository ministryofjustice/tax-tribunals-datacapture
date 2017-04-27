module Steps::Closure
  class CheckAnswersController < Steps::ClosureStepController
    before_action :authenticate_user!, only: [:resume]

    def show
      @presenter = closure_presenter

      respond_to do |format|
        format.html
        format.pdf { render @presenter.pdf_params }
      end
    end

    def resume
      @presenter = closure_presenter
    end

    private

    def closure_presenter
      CheckAnswers::ClosureAnswersPresenter.new(current_tribunal_case, format: request.format.symbol)
    end
  end
end
