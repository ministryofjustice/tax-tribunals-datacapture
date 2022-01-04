class RepresentativeDetailsPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/details/representative_details'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.representative_details.edit.heading')
    element :individual_rep,  'govuk-label', text: I18n.t('helpers.label.steps_details_representative_individual_details_form.representative_individual_first_name')
    sections :input_field, '.govuk-form-group' do
      element :input_label, '.govuk-label'
      element :individual_rep,  'govuk-label', text: I18n.t('helpers.label.steps_details_representative_individual_details_form.representative_individual_first_name')
      element :first_name_input, "input[name='steps_details_representative_individual_details_form[representative_individual_first_name]']"
      element :last_name_input, "input[name='steps_details_representative_individual_details_form[representative_individual_last_name]']"
      element :address_input, "textarea[name='steps_details_representative_individual_details_form[representative_contact_address]']"
      element :city_input, "input[name='steps_details_representative_individual_details_form[representative_contact_city]']"
      element :postcode_input, "input[name='steps_details_representative_individual_details_form[representative_contact_postcode]']"
      element :country_input, "input[name='steps_details_representative_individual_details_form[representative_contact_country]']"
      element :email_input, "input[name='steps_details_representative_individual_details_form[representative_contact_email]']"
      element :phone_input, "input[name='steps_details_representative_individual_details_form[representative_contact_phone]']"
      element :input_error, '.govuk-error-message'
      end
      section :error, '.govuk-error-summary' do
        # element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
        element :address_error, 'a', text: I18n.t('dictionary.blank_address')
        element :city_error, 'a', text: I18n.t('dictionary.blank_city')
        element :postcode_error, 'a', text: I18n.t('dictionary.blank_postcode')
        element :country_error, 'a', text: I18n.t('dictionary.blank_country')
        element :first_name_error, 'a', text: I18n.t('dictionary.blank_first_name')
        element :last_name_error, 'a', text: I18n.t('dictionary.blank_last_name')
      end
    end

  def individual_label
    expect(representative_details_page.content).to have_header
  end

  def submit_representative_details_with_email
    representative_details_page.content.input_field[0].first_name_input.set 'John'
    representative_details_page.content.input_field[1].last_name_input.set 'Smith'
    representative_details_page.content.input_field[2].address_input.set '102 Petty France'
    representative_details_page.content.input_field[3].city_input.set 'London'
    representative_details_page.content.input_field[4].postcode_input.set 'SW1H 9AJ'
    representative_details_page.content.input_field[5].country_input.set 'UK'
    representative_details_page.content.input_field[6].email_input.set 'matching@email.com'
    representative_details_page.content.input_field[7].phone_input.set '07777 888888'
    continue_or_save_continue
  end

  def submit_representative_details_without_email
    representative_details_page.content.input_field[0].first_name_input.set 'John'
    representative_details_page.content.input_field[1].last_name_input.set 'Smith'
    representative_details_page.content.input_field[2].address_input.set '102 Petty France'
    representative_details_page.content.input_field[3].city_input.set 'London'
    representative_details_page.content.input_field[4].postcode_input.set 'SW1H 9AJ'
    representative_details_page.content.input_field[5].country_input.set 'UK'
    representative_details_page.content.input_field[7].phone_input.set '07777 888888'
    continue_or_save_continue
  end

  def add_email_and_submit
    representative_details_page.content.input_field[6].email_input.set 'matching@email.com'
    continue_or_save_continue
  end
end
