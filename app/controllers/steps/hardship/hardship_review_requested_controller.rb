module Steps::Hardship
  class HardshipReviewRequestedController < Steps::HardshipStepController
    def edit
      @form_object = HardshipReviewRequestedForm.new(
        tribunal_case: current_tribunal_case,
        hardship_review_requested: current_tribunal_case.hardship_review_requested
      )
    end

    def update
      update_and_advance(HardshipReviewRequestedForm)
    end
  end
end
