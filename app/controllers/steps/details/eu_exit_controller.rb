module Steps::Details
  class EuExitController < Steps::DetailsStepController
    def edit
      @form_object = Steps::Shared::EuExitForm.new(
          tribunal_case: current_tribunal_case,
          eu_exit: current_tribunal_case.eu_exit
      )
      render template: 'steps/shared/eu_exit/edit'
    end

    def update
      if params[:steps_shared_eu_exit_form].nil?
        skip_eu_exit_page
      else
        update_and_advance(Steps::Shared::EuExitForm)
      end
    end

    private

    def skip_eu_exit_page
      redirect_to steps_details_outcome_path
    end
  end
end
