class Steps::Cost::ChallengedDecisionController < StepController
  def edit
    super
    @form_object = ChallengedDecisionForm.new(
      tribunal_case: current_tribunal_case,
      challenged_decision: current_tribunal_case.challenged_decision
    )
  end

  def update
    update_and_advance(:challenged_decision, ChallengedDecisionForm)
  end

  private

  def current_tribunal_case
    # This step, and only this step, should create a tribunal case if
    # there isn't one in the session - because it's the first
    super || TribunalCase.create.tap do |tribunal_case|
      session[:tribunal_case_id] = tribunal_case.id
    end
  end
end
