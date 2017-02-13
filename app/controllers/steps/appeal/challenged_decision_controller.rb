module Steps::Appeal
  class ChallengedDecisionController < Steps::AppealStepController
    def edit
      super
      @form_object = ChallengedDecisionForm.new(
        tribunal_case: current_tribunal_case,
        challenged_decision: current_tribunal_case.challenged_decision
      )
    end

    def update
      update_and_advance(ChallengedDecisionForm)
    end

    private

    def current_tribunal_case
      # This step, and only this step, should create a tribunal case if
      # there isn't one in the session - because it's the first
      # TODO: Reconsider where this should go - it's not very intuitive
      #   to be doing this here.
      super || initialize_tribunal_case(intent: Intent::TAX_APPEAL)
    end

    def update_navigation_stack
      # This is the first step in the appeal flow, so reset the navigation stack
      # before re-initialising it in StepController#update_navigation_stack
      current_tribunal_case.navigation_stack = []
      super
    end
  end
end
