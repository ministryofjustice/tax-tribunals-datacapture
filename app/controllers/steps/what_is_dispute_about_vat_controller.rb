class Steps::WhatIsDisputeAboutVatController < StepController
  def edit
    super
    @form_object = WhatIsDisputeAboutVatForm.new(
      tribunal_case: current_tribunal_case,
      what_is_dispute_about: current_tribunal_case.what_is_dispute_about
    )
  end

  def update
    update_and_advance(:what_is_dispute_about, WhatIsDisputeAboutVatForm, as: :what_is_dispute_about_vat)
  end
end
