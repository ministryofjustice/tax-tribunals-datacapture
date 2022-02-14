module Steps::Details
  class NeedSupportController < Steps::DetailsStepController
    def edit
      @form_object = Steps::Shared::NeedSupportForm.new(
        tribunal_case: current_tribunal_case,
        need_support: current_tribunal_case.need_support
      )
      render template: 'steps/shared/need_support/edit'
    end

    def update
      update_and_advance(Steps::Shared::NeedSupportForm,
        render: 'steps/shared/need_support/edit')
    end
  end
end
