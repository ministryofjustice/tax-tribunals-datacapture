module Steps::Appeal
  class CaseTypeController < Steps::AppealStepController
    def edit
      super
      @form_object = CaseTypeForm.new(
        tribunal_case: current_tribunal_case,
        case_type: current_tribunal_case.case_type
      )
    end

    def update
      update_and_advance(CaseTypeForm)
    end

    private

    def current_tribunal_case
      # This step, and only this step, should create a tribunal case if
      # there isn't one in the session - because it's the first
      # TODO: Reconsider where this should go - it's not very intuitive
      #   to be doing this here.
      super || initialize_tribunal_case(intent: Intent::TAX_APPEAL)
    end

    def update_navigation_stack
      # This is the first step in the appeal flow, so reset the navigation stack
      # before re-initialising it in StepController#update_navigation_stack
      current_tribunal_case.navigation_stack = []
      super
    end
  end
end
