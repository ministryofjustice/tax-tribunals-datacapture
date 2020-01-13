class SaveAppealPage < BasePage
  set_url '/users/sign_up'

  section :content, '#content' do
    element :header, 'h2', text: 'Save your appeal'
    elements :login_label, '.form-label'
    element :password_input, '#user_password'
    element :password_error, '.error-message', text: 'Your password must be at least 8 characters'
  end

  def save_and_come_back
    content.save_and_come_back.click
  end
end
