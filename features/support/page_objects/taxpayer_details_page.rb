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
end
