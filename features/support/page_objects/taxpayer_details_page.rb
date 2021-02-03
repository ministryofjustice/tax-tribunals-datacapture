class TaxpayerDetailsPage < BasePage
  set_url '/steps/details/taxpayer_details'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Enter taxpayer\'s details'
    sections :input_field, '.govuk-form-group' do
      element :input_label, '.govuk-label'
      element :first_name_input, '#steps-details-taxpayer-individual-details-form-taxpayer-individual-first-name-field'
      element :last_name_input, '#steps-details-taxpayer-individual-details-form-taxpayer-individual-last-name-field'
      element :address_input, '#steps-details-taxpayer-individual-details-form-taxpayer-contact-address-field'
      element :city_input, '#steps-details-taxpayer-individual-details-form-taxpayer-contact-city-field'
      element :postcode_input, '#steps-details-taxpayer-individual-details-form-taxpayer-contact-postcode-field'
      element :country_input, '#steps-details-taxpayer-individual-details-form-taxpayer-contact-country-field'
      element :email_input, '#steps-details-taxpayer-individual-details-form-taxpayer-contact-email-field'
      element :phone_input, '#steps-details-taxpayer-individual-details-form-taxpayer-contact-phone-field'
      element :input_error, '.govuk-error-message'
    end
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
    continue_or_save_continue
  end
end
