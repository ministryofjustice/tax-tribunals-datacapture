class TaxpayerDetailsPage < BasePage
  set_url '/steps/details/taxpayer_details'

  section :content, '#content' do
    element :header, 'h1', text: 'Enter taxpayer\'s details'
    element :button, '.button'
    sections :form_group, '.form-group' do
      element :first_name_label, 'label', text: 'First name'
      element :first_name_input, '#steps_details_taxpayer_individual_details_form_taxpayer_individual_first_name'
      element :last_name_label, 'label', text: 'Last name'
      element :last_name_input, '#steps_details_taxpayer_individual_details_form_taxpayer_individual_last_name'
      element :address_label, 'label', text: 'Address'
      element :address_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_address'
      element :city_label, 'label', text: 'City'
      element :city_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_city'
      element :postcode_label, 'label', text: 'Postcode'
      element :postcode_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_postcode'
      element :country_label, 'label', text: 'Country'
      element :country_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_country'
      element :email_address_label, 'label', text: 'Email address'
      element :email_address_input, '#steps_details_taxpayer_individual_details_form_taxpayer_contact_email'
    end
  end

  def successfully_submit_taxpayer_details
    content.form_group[0].first_name_input.set 'John'
    content.form_group[1].last_name_input.set 'Smith'
    content.form_group[2].address_input.set '102 Petty France'
    content.form_group[3].city_input.set 'London'
    content.form_group[4].postcode_input.set 'SW1H 9HE'
    content.form_group[5].country_input.set 'UK'
    content.form_group[6].email_address_input.set @email ||= "#{SecureRandom.uuid}@test.com"
  end
end