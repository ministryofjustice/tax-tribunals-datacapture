class SelectLanguagePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/select_language'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('dictionary.select_language_question')
    element :english_only_checkbox, 'label', text: I18n.t('dictionary.SUPPORTED_LANGUAGES.english')
    element :english_welsh_checkbox, 'label', text: I18n.t('dictionary.SUPPORTED_LANGUAGES.english_welsh')
  end

  def skip_save_and_return
    continue_or_save_continue
  end

  def select_english_only
    content.english_only_checkbox.click
    continue_or_save_continue
  end
end
