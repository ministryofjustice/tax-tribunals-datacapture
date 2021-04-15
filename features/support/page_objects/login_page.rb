class LoginPage < BasePage
  set_url '/en/users/login'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('helpers.submit.sign_in')
    element :email_input, '#user-signin-email-field'
    element :password_input, '#user-signin-password-field'
    element :sign_in_button, "input[value='" + I18n.t('helpers.submit.sign_in') + "']"
    section :error_summary, '.govuk-error-summary' do
      element :invalid_error, 'a', text: I18n.t('activemodel.errors.models.user/signin.attributes.base.invalid')
      element :blank_email_error, 'a', text: I18n.t('activemodel.errors.models.user/signin.attributes.email.blank')
      element :blank_password_error, 'a', text: I18n.t('activemodel.errors.models.user/signin.attributes.password.blank')
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
