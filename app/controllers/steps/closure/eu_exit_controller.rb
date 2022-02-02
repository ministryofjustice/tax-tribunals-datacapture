module Steps::Closure
  class EuExitController < Steps::ClosureStepController
    def edit
      @form_object = Steps::Shared::EuExitForm.new(
        tribunal_case: current_tribunal_case,
        eu_exit: current_tribunal_case.eu_exit
      )
      render template: 'steps/shared/eu_exit/edit'
    end

    def update
      update_and_advance(Steps::Shared::EuExitForm)
    end
  end
end
