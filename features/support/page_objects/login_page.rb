class LoginPage < BasePage
  set_url '/users/login'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Sign in'
  end
end
