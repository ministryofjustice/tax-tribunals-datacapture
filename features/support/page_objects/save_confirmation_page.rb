class SaveConfirmationPage < BasePage
  set_url '/users/registration/save_confirmation'

  section :content, '#content' do
    element :header, 'h1', text: 'Your case has been saved'
  end
end
