module Steps::Challenge
  class DecisionStatusController < Steps::ChallengeStepController
    def edit
      @form_object = DecisionStatusForm.new(
        tribunal_case: current_tribunal_case,
        challenged_decision_status: current_tribunal_case.challenged_decision_status
      )
    end

    def update
      update_and_advance(DecisionStatusForm)
    end
  end
end
