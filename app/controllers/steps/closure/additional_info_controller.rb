module Steps::Closure
  class AdditionalInfoController < Steps::ClosureStepController
    def edit
      @form_object = AdditionalInfoForm.new(
        tribunal_case: current_tribunal_case,
        closure_additional_info: current_tribunal_case.closure_additional_info
      )
    end

    def update
      update_and_advance(AdditionalInfoForm, as: :additional_info)
    end
  end
end
