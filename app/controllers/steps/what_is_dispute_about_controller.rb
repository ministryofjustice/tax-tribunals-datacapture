class Steps::WhatIsDisputeAboutController < StepController
  def edit
    super
    @form_object = WhatIsDisputeAboutForm.new(
      tribunal_case: current_tribunal_case,
      what_is_dispute_about: current_tribunal_case.what_is_dispute_about
    )
  end

  def update
    update_and_advance(:what_is_dispute_about, WhatIsDisputeAboutForm)
  end
end
