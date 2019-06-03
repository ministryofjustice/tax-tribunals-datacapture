class CaseTypePage < BasePage
  set_url '/steps/closure/case_type'

  section :content, '#content' do
    element :header, 'h1', text: 'What type of enquiry do you want to close?'
    element :one_on_list, 'p', text: 'The tax tribunal can only deal with applications to close the following enquiries.'
    element :personal_return, 'label', text: 'Personal return'
  end

  def go_to_case_type_page
    home_page.load_page
    home_page.close_enquiry
    closure_page.continue
  end

  def submit_personal_return
    case_type_page.content.personal_return.click
    continue
  end
end
