class ClosurePage < BasePage
  set_url '/closure'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Apply to close an enquiry'
    element :continue_button, '.govuk-button', text: 'Continue'
  end

  def continue
    content.continue_button.click
  end

  def go_to_closure_page
    home_page.load_page
    home_page.close_enquiry
  end
end
