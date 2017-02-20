module Steps::Details
  class UserTypeController < Steps::DetailsStepController
    def edit
      @form_object = UserTypeForm.new(
        tribunal_case: current_tribunal_case,
        user_type: current_tribunal_case.user_type
      )
    end

    def update
      update_and_advance(UserTypeForm)
    end
  end
end
