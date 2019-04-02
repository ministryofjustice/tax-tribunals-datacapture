module Steps::Details
  class WhatSupportController < Steps::DetailsStepController
    def edit
      @form_object = WhatSupportForm.new(
        tribunal_case: current_tribunal_case,
        language_interpreter: current_tribunal_case.language_interpreter,
        sign_language_interpreter: current_tribunal_case.sign_language_interpreter,
        hearing_loop: current_tribunal_case.hearing_loop,
        disabled_access: current_tribunal_case.disabled_access,
        other_support: current_tribunal_case.other_support,
        other_support_details: current_tribunal_case.other_support_details,
      )
    end

    def update
      update_and_advance(WhatSupportForm, as: :what_support)
    end
  end
end
