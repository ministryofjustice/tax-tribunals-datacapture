module Steps::Appeal
  class ChallengedDecisionStatusController < Steps::AppealStepController
    def edit
      super
      @form_object = ChallengedDecisionStatusForm.new(
        tribunal_case: current_tribunal_case,
        challenged_decision_status: current_tribunal_case.challenged_decision_status
      )
    end

    def update
      update_and_advance(ChallengedDecisionStatusForm)
    end
  end
end
