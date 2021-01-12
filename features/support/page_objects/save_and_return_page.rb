class SaveReturnPage < BasePage
  set_url '/steps/save_and_return'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Do you want to be able to save and return to this appeal?'
    element :create_account_checkbox, 'label', text: 'Create an account (optional)'
  end

  def skip_save_and_return
    continue
  end

  def create_new_account
    content.create_account_checkbox.click
    continue
  end
end
