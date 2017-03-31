module Steps::Challenge
  class DecisionController < Steps::ChallengeStepController
    def edit
      @form_object = DecisionForm.new(
        tribunal_case: current_tribunal_case,
        challenged_decision: current_tribunal_case.challenged_decision
      )
    end

    def update
      update_and_advance(DecisionForm)
    end
  end
end
