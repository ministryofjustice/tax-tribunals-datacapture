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
      update_and_advance(:<%= step_name.underscore %>, <%= step_name.camelize %>Form)
    end

    def previous_step_path
      # TODO: Update to e.g.:
      #   edit_steps_<%= task_name.underscore %>_PREVIOUSSTEP_path
      raise 'TODO: Define back link in controller'
    end
  end
end
