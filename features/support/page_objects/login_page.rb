class LoginPage < BasePage
  set_url '/users/login'

  section :content, '#content' do
    element :header, 'h1', text: 'Sign in'
    element :email_label, 'label', text: 'Your email address'
    element :email_input, '#user_signin_email'
    element :password_label, 'label', text: 'Enter password'
    element :password_input, '#user_signin_password'
    element :sign_in_button, "input[value='Sign in']"
  end

  def successfully_login
    content.email_input.set credentials_page.credentials[:valid_email]
    content.password_input.set credentials_page.credentials[:valid_password]
    content.sign_in_button.click
  end
end