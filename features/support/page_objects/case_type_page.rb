class CaseTypePage < BasePage
  set_url '/steps/closure/case_type'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What type of enquiry do you want to close?'
    element :one_on_list, '.govuk-hint'
    element :personal_return, 'label', text: 'Personal return'
  end

  def submit_personal_return
    case_type_page.content.personal_return.click
    continue
  end
end
