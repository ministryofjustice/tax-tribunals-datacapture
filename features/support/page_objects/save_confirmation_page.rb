class SaveConfirmationPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/users/registration/save_confirmation'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('users.logins.save_confirmation.heading')
    element :continue_button, '.govuk-button', text: I18n.t('users.shared.case_saved.continue')
  end
end
