class NeedSupportPage < BasePage
  set_url '/en/steps/details/need_support'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('check_answers.need_support.question')
  end
end
