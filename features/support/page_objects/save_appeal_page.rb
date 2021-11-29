class SaveAppealPage < BasePage
  set_url '/'+ ENV['TEST_LOCALE'] +'/users/sign_up'

  section :content, '#main-content' do
    element :appeal_header, 'h1', text: I18n.t('users.registrations.new.appeal_test')
    element :closure_header, 'h1', text: I18n.t('users.registrations.new.application_test')
    elements :login_label, '.govuk-label'
    element :email_input, '#user-email-field'
    element :password_input, '#user-password-field'
    element :error_message, '.govuk-error-message'
  end
end
