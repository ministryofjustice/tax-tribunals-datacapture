class SaveAppealPage < BasePage
  set_url '/users/sign_up'

  section :content, '#content' do
    element :header, 'h2', text: 'Save your appeal'
    elements :login_label, '.form-label'
    element :email_input, '#user_email'
    element :password_input, '#user_password'
    element :error_message, '.error-message', text: 'Enter a stronger password'
  end

  def save_and_come_back
    content.save_and_come_back.click
  end
end