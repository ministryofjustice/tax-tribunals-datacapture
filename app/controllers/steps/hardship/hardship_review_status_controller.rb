module Steps::Hardship
  class HardshipReviewStatusController < Steps::HardshipStepController
    def edit
      @form_object = HardshipReviewStatusForm.new(
        tribunal_case: current_tribunal_case,
        hardship_review_status: current_tribunal_case.hardship_review_status
      )
    end

    def update
      update_and_advance(HardshipReviewStatusForm)
    end
  end
end
