class SaveAppealPage < BasePage
  set_url '/users/sign_up'

  section :content, '#main-content' do
    element :appeal_header, 'h2', text: 'Save your appeal'
    element :closure_header, 'h2', text: 'Save your application'
    elements :login_label, '.govuk-label'
    element :email_input, '#user-email-field'
    element :password_input, '#user-password-field'
    element :error_message, '.govuk-error-message', text: 'Enter a stronger password'
  end
end
