class HomePage < BasePage
  set_url '/en/'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What do you want to do?'
    element :appeal_link, 'a', text: 'Appeal against a tax decision'
    element :close_enquiry_link, 'a', text: 'Apply to close an enquiry'
    element :return, 'a', text: 'Return to a saved appeal or application'
    element :view_guidance_link, 'a', text: 'View guidance before I start'
    element :time_information_tax, 'p', text: '(30 minutes to complete)'
    element :time_information_enquiry, 'p', text: '(15 minutes to complete)'
  end

  def appeal
    content.appeal_link.click
  end

  def close_enquiry
    content.close_enquiry_link.click
  end

  def return
    content.return.click
  end

  def view_guidance
    content.view_guidance_link.click
  end
end
