class TaxpayerDetailsPage < BasePage
  set_url '/steps/details/taxpayer_details'

  section :content, '#content' do
    element :header, 'h1', text: 'Enter taxpayer\'s details'
    sections :input_field, '.form-group' do
      element :input_label, '.form-label'
      element :first_name_input, '#steps_details_taxpayer_individual_details_form_taxpayer_individual_first_name'
      element :last_name_input, '#steps_details_taxpayer_individual_details_form_taxpayer_individual_last_name'
      element :address_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_address'
      element :city_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_city'
      element :postcode_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_postcode'
      element :country_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_country'
      element :email_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_email'
      element :phone_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_phone'
    end
  end

  def go_to_taxpayer_details_page
    home_page.load_page
    home_page.close_enquiry
    closure_page.continue
    case_type_page.submit_personal_return
    user_type_page.submit_yes
    base_page.submit_individual
  end

  def submit_taxpayer_details
    taxpayer_details_page.content.input_field[0].first_name_input.set 'John'
    taxpayer_details_page.content.input_field[1].last_name_input.set 'Smith'
    taxpayer_details_page.content.input_field[2].address_input.set '102 Petty France'
    taxpayer_details_page.content.input_field[3].city_input.set 'London'
    taxpayer_details_page.content.input_field[4].postcode_input.set 'SW1H 9AJ'
    taxpayer_details_page.content.input_field[5].country_input.set 'UK'
    taxpayer_details_page.content.input_field[6].email_input.set 'jsmith_test@test.com'
    taxpayer_details_page.content.input_field[7].phone_input.set '07777 888888'
    continue
  end
end
