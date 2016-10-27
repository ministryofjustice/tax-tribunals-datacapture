class Steps::WhatIsAppealAboutUnchallengedController < StepController
  def edit
    super
    @form_object = WhatIsAppealAboutForm.new(
      tribunal_case: current_tribunal_case,
      what_is_appeal_about: current_tribunal_case.what_is_appeal_about
    )
  end

  def update
    update_and_advance(:what_is_appeal_about, WhatIsAppealAboutForm, as: :what_is_appeal_about_unchallenged)
  end
end
