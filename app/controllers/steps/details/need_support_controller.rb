module Steps::Details
  class NeedSupportController < Steps::DetailsStepController
    def edit
      @form_object = NeedSupportForm.new(
        tribunal_case: current_tribunal_case,
        need_support: current_tribunal_case.need_support
      )
    end

    def update
      update_and_advance(NeedSupportForm)
    end
  end
end
