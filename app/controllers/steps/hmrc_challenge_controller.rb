class Steps::HmrcChallengeController < StepController
  def edit
    super
    @form_object = DidChallengeHmrcForm.new
  end

  def update
  end
end
