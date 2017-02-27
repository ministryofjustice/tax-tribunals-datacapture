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

  # Renders a back link without the progress information, as kickout pages are not
  # really question pages, but the end of a journey
  def endpoint_step_header
    step_header(nil, nil)
  end

  def translate_for_user_type(key, params={})
    suffix = '_html' if key.end_with?('_html')
    translate_with_appeal_or_application("#{key}.as_#{current_tribunal_case.user_type}#{suffix}", params)
  end

  def translate_with_appeal_or_application(key, params={})
    translate(key, params.merge(appeal_or_application_params))
  end

  def appeal_or_application_params
    {appeal_or_application: I18n.translate("generic.appeal_or_application.#{current_tribunal_case.appeal_or_application}")}
  end
end
