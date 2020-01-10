class SaveAppealPage < BasePage
  set_url '/users/sign_up'

  section :content, '#content' do
    element :header, 'h2', text: 'Save your appeal'
    element :choose_password, '.form-label', text: 'Choose password Must be at least 8 characters'
    element :password_input, '#user_password'
    element :password_error, '.error-message'
  end

  def save_and_come_back
    content.save_and_come_back.click
  end
end
