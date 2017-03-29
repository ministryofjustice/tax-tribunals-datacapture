module Steps::Details
  class CheckAnswersController < Steps::DetailsStepController
    respond_to :html, :pdf

    def show
      @presenter = CheckAnswers::AppealAnswersPresenter.new(current_tribunal_case, format: request.format.symbol)

      respond_to do |format|
        format.html
        format.pdf { render pdf: 'check_answers' }
      end
    end
  end
end
