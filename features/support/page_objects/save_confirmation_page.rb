class SaveConfirmationPage < BasePage
  set_url '/en/users/registration/save_confirmation'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Your case has been saved'
    element :continue_button, '.govuk-button', text: 'Continue'
  end
end
