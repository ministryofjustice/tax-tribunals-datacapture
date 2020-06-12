class RepresentativePage < BasePage
  set_url '/steps/details/has_representative'

  section :content, '#content' do
    element :header, 'h1', text: 'Do you have someone to represent you?'
    element :representative, 'p', text: 'A representative is anyone you want to receive correspondence or go to a hearing for you. You can authorise a representative at any time during your appeal.'
  end

  def go_to_representative_page
    home_page.load_page
    home_page.close_enquiry
    closure_page.continue
    case_type_page.submit_personal_return
    user_type_page.submit_yes
    base_page.submit_individual
    taxpayer_details_page.submit_taxpayer_details
  end
end
