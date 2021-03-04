class NeedSupportPage < BasePage
  set_url '/en/steps/details/need_support'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Do you need any support at the hearing?'
  end
end
