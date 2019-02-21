class SaveAppealPage < BasePage
  set_url '/users/sign_up'

  element :header, 'h1'
  element :email_label, 'label', text: 'Your email address'
  element :email_input, '#user_email'
  element :password_label, 'label', text: 'Choose password'
  element :password_hint, '.form-hint', text: 'Must be at least 8 characters'
  element :password_input, '#user_password'
  element :save_button, "input[value='Save']"

  def succesfully_save_appeal
    email_input.set credentials_page.credentials[:valid_email]
    password_input.set credentials_page.credentials[:valid_password]
    save_button.click
  end
end