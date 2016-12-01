module ApplicationHelper
  # Render a form_for tag pointing to the update action of the current controller
  def step_form(record, options = {}, &block)
    opts = {
      url: { controller: controller.controller_path, action: :update },
      method: :put
    }.merge(options)

    form_for record, opts, &block
  end

  # Render a back link pointing to a controller-defined previous step, and a step
  # header to show the user how far they have come in the task
  def step_header(task, step_number)
    render partial: 'step_header', locals: {
      task:        task,
      step_number: step_number,
      path:        controller.previous_step_path
    }
  end
end
