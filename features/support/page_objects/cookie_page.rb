class CookiePage < BasePage
  set_url '/cookies'

  element :success, 'h2', text: 'Success'
  section :content, '#main-content' do
    element :header, 'h1', text: 'Cookies'
    element :save_cookies, "input[type='submit']"
  end

end
