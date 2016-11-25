module Steps::<%= task_name.classify %>
  class <%= step_name.classify %>Controller < Steps::<%= task_name.classify %>StepController
    def edit
      super
      @form_object = <%= step_name.classify %>Form.new(
        tribunal_case: current_tribunal_case,
        <%= step_name.underscore  %>: current_tribunal_case.<%= step_name.underscore %>
      )
      @back_link_path = (raise 'TODO: Specify the back link path for this generated controller')
    end

    def update
      update_and_advance(:<%= step_name.underscore %>, <%= step_name.classify %>Form)
    end
  end
end
