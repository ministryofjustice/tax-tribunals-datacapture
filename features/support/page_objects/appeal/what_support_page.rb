class WhatSupportPage < BasePage
  set_url '/en/steps/details/what_support'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Support at the hearing'
    element :language_interpreter_checkbox, 'label', text: 'Language interpreter'
    element :language_interpreter_textbox, '#steps-details-what-support-form-language-interpreter-details-field'
    element :sign_language_checkbox, 'label', text: 'Sign language interpreter'
    element :sign_language_textbox, '#steps-details-what-support-form-sign-language-interpreter-details-field'
    element :hearing_loop_checkbox, 'label', text: 'Hearing loop'
    element :accessible_hearing_room_checkbox, 'label', text: 'Accessible hearing rooms'
    element :other_support_checkbox, 'label', text: 'Other support'
    element :other_support_textarea, '#steps-details-what-support-form-other-support-details-field'
    section :error_summary, '.govuk-error-summary__body' do
      element :nothing_selected_error, 'a', text: 'Select what support you need at the hearing'
      element :blank_language_interpreter_error, 'a', text: 'Please enter what language needs to be interpreted'
      element :blank_sign_language_error, 'a', text: 'Please enter the sign language you need'
      element :blank_other_support_error, 'a', text: 'Please enter what other support you need'
    end
  end
end
