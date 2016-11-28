module Steps::<%= task_name.camelize %>
  class <%= step_name.camelize %>Form < BaseForm
    # TODO: Add more attributes or change type if necessary
    attribute :<%= step_name.underscore %>, String

    # TODO: Choices
    #   - Uncomment the below if you have a value object
    #   - Delete the method if you haven't
    #
    # def self.choices
    #  <%= step_name.camelize %>.values.map(&:to_s)
    # end
    # validates_inclusion_of :<%= step_name.underscore %>, in: choices

    # TODO: Add any further validations here

    private

    # TODO:
    #   - Uncomment the below if you have a value object
    #   - Delete the method if you haven't
    # def <%= step_name.underscore %>_value
    #  <%= step_name.camelize %>.new(<%= step_name %>)
    # end

    def changed?
      # TODO: Make this return whether the form data has changed from the current
      #  state of the tribunal_case object. If you have a value object, you could
      #  do e.g.:
      #
      #  tribunal_case.<%= step_name.underscore %> != <%= step_name.underscore %>_value
      raise 'TODO: Update <%= step_name.camelize %>#changed?'
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return unless changed?

      # TODO: Update this to persist your form object
      tribunal_case.update(
        <%= step_name.underscore %>: (raise 'TODO: Update <%= step_name.camelize %>#persist!')
        # The following are dependent attributes that need to be reset
        # TODO: Are there any dependent attributes? Reset them here.
      )
    end
  end
end
