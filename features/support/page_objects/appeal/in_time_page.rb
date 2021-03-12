class InTimePage < BasePage
  set_url '/en/steps/lateness/in_time'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Are you in time to appeal to the tax tribunal?'
    element :yes_option, 'label', text: 'Yes, I am in time'
    element :no_option, 'label', text: 'No, I am late'
  end

  def submit_yes
    content.yes_option.click
    continue_or_save_continue
  end

  def submit_no
    content.no_option.click
    continue_or_save_continue
  end
end
