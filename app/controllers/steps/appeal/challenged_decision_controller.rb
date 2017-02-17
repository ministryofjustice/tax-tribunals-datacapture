module Steps::Appeal
  class ChallengedDecisionController < Steps::AppealStepController
    def edit
      @form_object = ChallengedDecisionForm.new(
        tribunal_case: current_tribunal_case,
        challenged_decision: current_tribunal_case.challenged_decision
      )
    end

    def update
      update_and_advance(ChallengedDecisionForm)
    end
  end
end
