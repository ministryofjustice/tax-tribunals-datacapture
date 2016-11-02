class Steps::WhatIsDisputeAboutIncomeTaxController < StepController
  def edit
    super
    @form_object = WhatIsDisputeAboutIncomeTaxForm.new(
      tribunal_case: current_tribunal_case,
      what_is_dispute_about: current_tribunal_case.what_is_dispute_about
    )
  end

  def update
    update_and_advance(:what_is_dispute_about, WhatIsDisputeAboutIncomeTaxForm, as: :what_is_dispute_about_income_tax)
  end
end
