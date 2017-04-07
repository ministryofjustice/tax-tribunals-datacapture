module ApplicationHelper
  # Render a form_for tag pointing to the update action of the current controller
  def step_form(record, options = {}, &block)
    opts = {
      url: { controller: controller.controller_path, action: :update },
      method: :put
    }.merge(options)

    # Support for appending optional css classes, maintaining the default one
    opts.merge!(
      html: { class: dom_class(record, :edit) }
    ) do |_key, old_value, new_value|
      { class: old_value.values | new_value.values }
    end

    form_for record, opts, &block
  end

  # Render a back link pointing to the user's previous step
  def step_header
    capture do
      render partial: 'step_header', locals: {
        path: controller.previous_step_path
      }
    end + error_summary(@form_object)
  end

  def error_summary(form_object)
    return if form_object.nil?

    GovukElementsErrorsHelper.error_summary(
      form_object,
      translate('errors.error_summary.heading'),
      translate('errors.error_summary.text')
    )
  end

  def translate_for_user_type(key, params={})
    suffix = '_html' if key.end_with?('_html')
    translate_with_appeal_or_application("#{key}.as_#{current_tribunal_case.user_type}#{suffix}", params)
  end

  def translate_with_appeal_or_application(key, params={})
    translate(key, params.merge(appeal_or_application_params))
  end

  def appeal_or_application_params
    appeal_or_application = translate("generic.appeal_or_application.#{current_tribunal_case.appeal_or_application}")

    {
      appeal_or_application: appeal_or_application,
      appeal_or_application_capitalised: appeal_or_application.upcase_first
    }
  end

  def analytics_tracking_id
    ENV['GA_TRACKING_ID']
  end

  def save_and_return_enabled?
    Rails.configuration.x.features.save_and_return_enabled
  end
end
