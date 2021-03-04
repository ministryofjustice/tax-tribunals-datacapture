class LoginPage < BasePage
  set_url '/en/users/login'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Sign in'
    element :email_input, '#user-signin-email-field'
    element :password_input, '#user-signin-password-field'
    element :sign_in_button, "input[value='Sign in']"
    section :error_summary, '.govuk-error-summary' do
      element :invalid_error, 'a', text: 'Enter a valid email and password'
      element :blank_email_error, 'a', text: 'Please enter your email address'
      element :blank_password_error, 'a', text: 'Please enter a password'
    end
  end

  def click_sign_in
    content.sign_in_button.click
  end

  def invalid_sign_in
    content.email_input.set 'Invalid@email.com'
    content.password_input.set 'Invalid password'
    content.sign_in_button.click
  end
end
