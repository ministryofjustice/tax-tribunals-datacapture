class CaseTypePage < BasePage
  set_url %r{/case_type$}

  section :content, '#main-content' do
    element :closure_header, 'h1', text: 'What type of enquiry do you want to close?'
    element :appeal_header, 'h1', text: 'What is your appeal about?'
    element :one_on_list, '.govuk-hint'
    element :personal_return, 'label', text: 'Personal return'
    element :income_tax, 'label', text: %r{Income Tax}
  end

  def submit_personal_return
    case_type_page.content.personal_return.click
    continue
  end

  def submit_income_tax
    case_type_page.content.income_tax.click
    continue
  end
end
