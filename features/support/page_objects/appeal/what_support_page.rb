class WhatSupportPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/what_support'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.what_support.edit.heading')
    element :language_interpreter_checkbox, 'label', text: I18n.t('helpers.label.steps_details_what_support_form.language_interpreter_options.language_interpreter')
    element :language_interpreter_textbox, '#steps-details-what-support-form-language-interpreter-details-field'
    element :sign_language_checkbox, 'label', text: I18n.t('helpers.label.steps_details_what_support_form.sign_language_interpreter_options.sign_language_interpreter')
    element :sign_language_textbox, '#steps-details-what-support-form-sign-language-interpreter-details-field'
    element :hearing_loop_checkbox, 'label', text: I18n.t('helpers.label.steps_details_what_support_form.hearing_loop_options.hearing_loop')
    element :accessible_hearing_room_checkbox, 'label', text: I18n.t('helpers.label.steps_details_what_support_form.disabled_access_options.disabled_access')
    element :other_support_checkbox, 'label', text: I18n.t('helpers.label.steps_details_what_support_form.other_support_options.other_support')
    element :other_support_textarea, '#steps-details-what-support-form-other-support-details-field'
    section :error_summary, '.govuk-error-summary__body' do
      element :nothing_selected_error, 'a', text: I18n.t('activemodel.errors.models.steps/details/what_support_form.attributes.what_support')
      element :blank_language_interpreter_error, 'a', text: I18n.t('activemodel.errors.models.steps/details/what_support_form.attributes.language_interpreter_details.blank')
      element :blank_sign_language_error, 'a', text: I18n.t('activemodel.errors.models.steps/details/what_support_form.attributes.sign_language_interpreter_details.blank')
      element :blank_other_support_error, 'a', text: I18n.t('activemodel.errors.models.steps/details/what_support_form.attributes.other_support_details.blank')
    end
  end
end
