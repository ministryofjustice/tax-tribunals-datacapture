class HomePage < BasePage
  set_url '/'

  section :content, '#content' do
    element :header, 'h1', text: 'What do you want to do?'
    element :close_enquiry_link, 'a', text: 'Apply to close an enquiry'
    element :time_information_tax, 'p', text: '(30 minutes to complete)'
    element :time_information_enquiry, 'p', text: '(15 minutes to complete)'
  end

  def close_enquiry
    content.close_enquiry_link.click
  end
end
