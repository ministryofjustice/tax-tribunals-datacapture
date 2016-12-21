module Steps::<%= task_name.camelize %>
  class <%= step_name.camelize %>Controller < Steps::<%= task_name.camelize %>StepController
    def edit
      super
      @form_object = <%= step_name.camelize %>Form.new(
        tribunal_case: current_tribunal_case,
        <%= step_name.underscore  %>: current_tribunal_case.<%= step_name.underscore %>
      )
    end

    def update
      update_and_advance(<%= step_name.camelize %>Form)
    end
  end
end
