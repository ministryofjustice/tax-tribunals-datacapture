class LoginPage < BasePage
  set_url '/users/login'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Sign in'
    element :email_input, '#user-signin-email-field'
    element :password_input, '#user-signin-password-field'
    element :sign_in_button, "input[value='Sign in']"
    element :error_message, '.govuk-error-summary'
  end
end
