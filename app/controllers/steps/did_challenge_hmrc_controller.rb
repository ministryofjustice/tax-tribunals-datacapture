class Steps::DidChallengeHmrcController < StepController
  def edit
    super
    @form_object = DidChallengeHmrcForm.new(current_tribunal_case)
  end

  def update
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
