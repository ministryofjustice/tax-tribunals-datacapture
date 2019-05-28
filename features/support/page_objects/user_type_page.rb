class UserTypePage < BasePage
  set_url '/steps/details/user_type'

  section :content, '#content' do
    element :header, 'h1', text: 'Are you the taxpayer making the application?'
    element :yes, 'label', text: 'Yes'
    element :no, 'label', text: 'No'
  end

  def go_to_user_type_page
    home_page.load_page
    home_page.close_enquiry
    closure_page.continue
    case_type_page.submit_personal_return
  end

  def submit_yes
    content.yes.click
    continue
  end

  def submit_no
    content.no.click
    continue
  end
end
