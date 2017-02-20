module Steps::Details
  class OutcomeController < Steps::DetailsStepController
    def edit
      @form_object = OutcomeForm.new(
        tribunal_case: current_tribunal_case,
        outcome: current_tribunal_case.outcome
      )
    end

    def update
      update_and_advance(OutcomeForm)
    end
  end
end
