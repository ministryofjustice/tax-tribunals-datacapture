class AppealPage < BasePage
  set_url '/appeal'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Your appeal will be decided by an independent tribunal'
  end
end
