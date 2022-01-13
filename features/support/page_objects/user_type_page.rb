class UserTypePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/user_type'

  section :content, '#main-content' do
    element :closure_header, 'h1', text: I18n.t('helpers.fieldset.steps_details_user_type_form.user_type_application')
    element :appeal_header, 'h1', text: I18n.t('helpers.fieldset.steps_details_user_type_form.user_type_html')
    element :representative_information_dropdown, 'span', text: I18n.t('steps.shared.representative_explanation.heading')
    element :representative_dropdown_content, 'p', text: "A representative can be a:"
    section :error, '.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def representative_dropdown
    content.representative_information_dropdown.click
  end
end
