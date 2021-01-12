class NeedSupportPage < BasePage
  set_url '/steps/details/need_support'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Do you need any support at the hearing?'
    element :yes_option, 'label', text: 'Yes'
    element :no_option, 'label', text: 'No'
  end

  def submit_yes
    content.yes_option.click
    continue
  end

  def submit_no
    content.no_option.click
    continue
  end
end
