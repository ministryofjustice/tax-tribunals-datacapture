class Steps::WhatIsLatePenaltyOrSurchargeController < StepController
  def edit
    super
    @form_object = WhatIsLatePenaltyOrSurchargeForm.new(
      tribunal_case: current_tribunal_case,
      what_is_penalty_or_surcharge_amount: current_tribunal_case.what_is_penalty_or_surcharge_amount
    )
  end

  def update
    update_and_advance(:what_is_late_penalty_or_surcharge, WhatIsLatePenaltyOrSurchargeForm, as: :what_is_late_penalty_or_surcharge)
  end
end
