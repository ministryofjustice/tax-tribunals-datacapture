module Steps::Details
  class CheckAnswersController < Steps::DetailsStepController
    def show
      raise 'No tribunal case in session' unless current_tribunal_case

      @fee_details_answers = FeeDetailsAnswersPresenter.new(current_tribunal_case)
      @appeal_timeliness_answers = AppealTimelinessAnswersPresenter.new(current_tribunal_case)
      @appellant_details = AppellantDetailsPresenter.new(current_tribunal_case)
      @documents_submitted = DocumentsSubmittedPresenter.new(current_tribunal_case)
    end
  end
end
