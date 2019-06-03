class TaxpayerDetailsPage < BasePage
  set_url '/steps/details/taxpayer_details'

  section :content, '#content' do
    element :header, 'h1', text: 'Enter taxpayer\'s details'
  end

  def go_to_taxpayer_details_page
    home_page.load_page
    home_page.close_enquiry
    closure_page.continue
    case_type_page.submit_personal_return
    user_type_page.submit_yes
    base_page.submit_individual
  end
end
