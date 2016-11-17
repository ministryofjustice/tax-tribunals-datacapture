class Steps::Lateness::LatenessReasonController < StepController
  def edit
    super
    @form_object = LatenessReasonForm.new(
      tribunal_case:   current_tribunal_case,
      lateness_reason: current_tribunal_case.lateness_reason
    )
  end

  def update
    update_and_advance(:lateness_reason, LatenessReasonForm)
  end
end
