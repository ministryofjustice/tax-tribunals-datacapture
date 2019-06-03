class HomePage < BasePage
  set_url '/'

  section :content, '#content' do
    element :header, 'h1', text: 'What do you want to do?'
    element :close_enquiry_link, 'a', text: 'Apply to close an enquiry'
  end

  def close_enquiry
    content.close_enquiry_link.click
  end
end
