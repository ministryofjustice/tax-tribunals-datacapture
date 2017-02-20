module Steps::Details
  class GroundsForAppealController < Steps::DetailsStepController
    def edit
      @form_object = GroundsForAppealForm.new(
        tribunal_case: current_tribunal_case,
        grounds_for_appeal: current_tribunal_case.grounds_for_appeal,
      )
    end

    def update
      update_and_advance(GroundsForAppealForm, as: :grounds_for_appeal)
    end
  end
end
