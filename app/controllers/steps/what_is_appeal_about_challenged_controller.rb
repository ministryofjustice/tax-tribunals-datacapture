class Steps::WhatIsAppealAboutChallengedController < StepController
  def edit
    super
    @form_object = WhatIsAppealAboutChallengedForm.new(
      tribunal_case: current_tribunal_case,
      what_is_appeal_about: current_tribunal_case.what_is_appeal_about
    )
  end

  def update
    update_and_advance(:what_is_appeal_about, WhatIsAppealAboutChallengedForm, as: :what_is_appeal_about_challenged)
  end
end
