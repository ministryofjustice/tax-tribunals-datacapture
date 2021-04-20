class SaveAppealPage < BasePage
  set_url '/en/users/sign_up'

  section :content, '#main-content' do
    element :appeal_header, 'h2', text: I18n.t('users.registrations.new.appeal_test')
    element :closure_header, 'h2', text: I18n.t('users.registrations.new.application_test')
    elements :login_label, '.govuk-label'
    element :email_input, '#user-email-field'
    element :password_input, '#user-password-field'
    element :error_message, '.govuk-error-message', text: I18n.t('activerecord.errors.models.user.attributes.password.too_short')
  end
end
