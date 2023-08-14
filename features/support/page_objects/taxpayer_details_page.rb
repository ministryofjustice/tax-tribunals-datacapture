class TaxpayerDetailsPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/taxpayer_details'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.taxpayer_details.edit.heading')
    element :email_error, 'a', text: I18n.t('activerecord.errors.models.user.attributes.email.blank')
    sections :input_field, '.govuk-form-group' do
      element :input_label, '.govuk-label'
      element :first_name_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_individual_first_name]']"
      element :last_name_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_individual_last_name]']"
      element :address_input, "textarea[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_address]']"
      element :city_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_city]']"
      element :postcode_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_postcode]']"
      element :country_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_country]']"
      element :email_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_email]']"
      element :phone_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_phone]']"
      element :input_error, '.govuk-error-message'
    end
  end

  def submit_taxpayer_details
    taxpayer_details_page.content.input_field[0].first_name_input.set 'John'
    taxpayer_details_page.content.input_field[1].last_name_input.set 'Smith'
    if page.has_link?('Enter address manually')
      page.click_link('Enter address manually')
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-address-field', with: "102 Petty France"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-city-field', with: "London"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-postcode-field', with: "SW1H 9AJ"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-country-field', with: "UK"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-email-field', with: "matching@email.com"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-phone-field', with: "07777 888888"
    else
      taxpayer_details_page.content.input_field[2].address_input.set '102 Petty France'
      taxpayer_details_page.content.input_field[3].city_input.set 'London'
      taxpayer_details_page.content.input_field[4].postcode_input.set 'SW1H 9AJ'
      taxpayer_details_page.content.input_field[5].country_input.set 'UK'
      taxpayer_details_page.content.input_field[6].email_input.set 'matching@email.com'
      taxpayer_details_page.content.input_field[7].phone_input.set '07777 888888'
    end
    continue_or_save_continue
  end

  def submit_some_taxpayer_details
    taxpayer_details_page.content.input_field[0].first_name_input.set 'John'
    taxpayer_details_page.content.input_field[1].last_name_input.set 'Smith'
    if page.has_link?('Enter address manually')
      page.click_link('Enter address manually')
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-address-field', with: "102 Petty France"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-city-field', with: "London"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-postcode-field', with: "SW1H 9AJ"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-country-field', with: "UK"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-email-field', with: "matching@email"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-phone-field', with: "07777 888888"
    else
      taxpayer_details_page.content.input_field[2].address_input.set '102 Petty France'
      taxpayer_details_page.content.input_field[3].city_input.set 'London'
      taxpayer_details_page.content.input_field[4].postcode_input.set 'SW1H 9AJ'
      taxpayer_details_page.content.input_field[5].country_input.set 'UK'
      taxpayer_details_page.content.input_field[6].email_input.set 'matching@email'
      taxpayer_details_page.content.input_field[7].phone_input.set '07777 888888'
    end
    continue_or_save_continue
  end

  def resubmit_valid_email
    if page.has_link?('Enter address manually')
      page.click_link('Enter address manually')
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-email-field', with: "matching@email.com"
    else
      taxpayer_details_page.content.input_field[6].email_input.set 'matching@email.com'
    end
    continue_or_save_continue
  end

  def submit_without_taxpayer_phone
    taxpayer_details_page.content.input_field[0].first_name_input.set 'John'
    taxpayer_details_page.content.input_field[1].last_name_input.set 'Smith'
    if page.has_link?('Enter address manually')
      page.click_link('Enter address manually')
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-address-field', with: "102 Petty France"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-city-field', with: "London"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-postcode-field', with: "SW1H 9AJ"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-country-field', with: "UK"
      page.fill_in 'steps-details-taxpayer-individual-details-form-taxpayer-contact-email-field', with: "matching@email.com"
    else
      taxpayer_details_page.content.input_field[2].address_input.set '102 Petty France'
      taxpayer_details_page.content.input_field[3].city_input.set 'London'
      taxpayer_details_page.content.input_field[4].postcode_input.set 'SW1H 9AJ'
      taxpayer_details_page.content.input_field[5].country_input.set 'UK'
      taxpayer_details_page.content.input_field[6].email_input.set 'matching@email.com'
    end
    continue_or_save_continue
  end
end
