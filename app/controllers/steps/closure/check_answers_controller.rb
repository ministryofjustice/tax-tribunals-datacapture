module Steps::Closure
  class CheckAnswersController < Steps::ClosureStepController
    respond_to :html, :pdf

    def show
      @presenter = CheckAnswers::ClosureAnswersPresenter.new(current_tribunal_case, format: request.format.symbol)

      respond_to do |format|
        format.html
        format.pdf { render @presenter.pdf_params }
      end
    end
  end
end
