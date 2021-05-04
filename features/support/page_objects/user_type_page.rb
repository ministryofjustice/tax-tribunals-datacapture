class UserTypePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/user_type'

  section :content, '#main-content' do
    element :closure_header, 'h1', text: I18n.t('helpers.fieldset.steps_details_user_type_form.user_type_application')
    element :appeal_header, 'h1', text: I18n.t('helpers.fieldset.steps_details_user_type_form.user_type_html')
  end
end
