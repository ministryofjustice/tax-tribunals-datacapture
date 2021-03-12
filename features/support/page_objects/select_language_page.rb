class SelectLanguagePage < BasePage
  set_url '/en/steps/select_language'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What language do you want us to use when we contact you?'
    element :english_only_checkbox, 'label', text: 'English only'
    element :english_welsh_checkbox, 'label', text: 'English and Welsh'
  end

  def skip_save_and_return
    continue_or_save_continue
  end

  def select_english_only
    content.english_only_checkbox.click
    continue_or_save_continue
  end
end
