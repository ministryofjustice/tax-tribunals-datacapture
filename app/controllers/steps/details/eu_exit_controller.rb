module Steps::Details
  class EuExitController < Steps::DetailsStepController
    def edit
      @form_object = EuExitForm.new(
          tribunal_case: current_tribunal_case,
          eu_exit: current_tribunal_case.eu_exit
      )
    end

    def update
      if params[:steps_details_eu_exit_form].nil?
        skip_eu_exit_page
      else
        update_and_advance(EuExitForm)
      end
    end

    private

    def skip_eu_exit_page
      redirect_to steps_details_outcome_path
    end
  end
end
