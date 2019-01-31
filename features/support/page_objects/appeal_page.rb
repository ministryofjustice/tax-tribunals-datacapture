class AppealPage < BasePage
  set_url '/appeal'

  section :content, '#content' do
    element :header, 'h1', text: 'Get an impartial decision on your dispute'
    element :next_button, 'a', text: 'Continue'
  end
end
