module Steps::Hardship
  class HardshipReasonController < Steps::HardshipStepController
    def edit
      @form_object = HardshipReasonForm.new(
        tribunal_case: current_tribunal_case,
        hardship_reason: current_tribunal_case.hardship_reason
      )
    end

    def update
      update_and_advance(HardshipReasonForm)
    end
  end
end
