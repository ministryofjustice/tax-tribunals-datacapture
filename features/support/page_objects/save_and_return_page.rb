class SaveReturnPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/save_and_return'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.save_and_return.edit.page_title')
    element :create_account_checkbox, 'label', text: I18n.t('steps.save_and_return.edit.answers.save_for_later')
  end

  def skip_save_and_return
    continue_or_save_continue
  end

  def create_new_account
    content.create_account_checkbox.click
    continue_or_save_continue
  end
end
