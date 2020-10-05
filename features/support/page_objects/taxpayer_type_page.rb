class TaxpayerTypePage < BasePage
  set_url '/steps/details/taxpayer_type'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Who is making the application?'
  end

  def go_to_taxpayer_type_page
    home_page.load_page
    home_page.close_enquiry
    closure_page.continue
    case_type_page.submit_personal_return
    user_type_page.submit_yes
  end

  def submit_company
    content.company.click
    continue
  end

  def submit_other
    content.other.click
    continue
  end
end
