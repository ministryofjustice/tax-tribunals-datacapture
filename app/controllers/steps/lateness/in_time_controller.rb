module Steps::Lateness
  class InTimeController < Steps::LatenessStepController
    def edit
      super
      @form_object = InTimeForm.new(
        tribunal_case: current_tribunal_case,
        in_time:       current_tribunal_case.in_time
      )
    end

    def update
      update_and_advance(:in_time, InTimeForm)
    end
  end
end
