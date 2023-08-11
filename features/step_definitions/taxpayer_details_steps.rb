Given("I navigate to the closure taxpayer details page as a taxpayer") do
  navigate_to_closure_taxpayer_details_page(:taxpayer_user_type)
end

Given("I navigate to the closure taxpayer details page as a representative") do
  navigate_to_closure_taxpayer_details_page(:representative_user_type)
end

When("I successfully submit taxpayers details") do
  expect(taxpayer_details_page.content).to have_header
  expect(taxpayer_details_page.content.input_field[0].input_label.text).to eq I18n.t('helpers.label.steps_details_taxpayer_individual_details_form.taxpayer_individual_first_name')
  expect(taxpayer_details_page.content.input_field[1].input_label.text).to eq I18n.t('helpers.label.steps_details_taxpayer_individual_details_form.taxpayer_individual_last_name')
  expect(taxpayer_details_page.content.input_field[2].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_address')
  expect(taxpayer_details_page.content.input_field[3].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_city')
  expect(taxpayer_details_page.content.input_field[4].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_postcode')
  expect(taxpayer_details_page.content.input_field[5].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_country')
  expect(taxpayer_details_page.content.input_field[6].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_email')
  expect(taxpayer_details_page.content.input_field[7].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_phone')
  taxpayer_details_page.submit_taxpayer_details
end

When("I submit a blank taxpayers details form") do
  expect(taxpayer_details_page.content).to have_header
  continue_or_save_continue
end

Then("I am taken to the send taxpayer copy page") do
  expect(send_taxpayer_copy_page.content).to have_header
end

Then("I am shown all the taxpayer details errors") do
  expect(taxpayer_details_page.content.input_field[0].input_error.text).to have_content(I18n.t('dictionary.blank_first_name'))
  expect(taxpayer_details_page.content.input_field[1].input_error.text).to have_content(I18n.t('dictionary.blank_last_name'))
  expect(taxpayer_details_page.content.input_field[2].input_error.text).to have_content(I18n.t('dictionary.blank_address'))
  expect(taxpayer_details_page.content.input_field[3].input_error.text).to have_content(I18n.t('dictionary.blank_city'))
  expect(taxpayer_details_page.content.input_field[4].input_error.text).to have_content(I18n.t('dictionary.blank_postcode'))
  expect(taxpayer_details_page.content.input_field[5].input_error.text).to have_content(I18n.t('dictionary.blank_country'))
  expect(taxpayer_details_page.content.input_field[6].input_error.text).to have_content(I18n.t('dictionary.blank_email'))
end

Then("I am on the taxpayer details page") do
  expect(taxpayer_details_page.content).to have_header
end

When(/^I submit a taxpayers details form with an invalid email$/) do
  expect(taxpayer_details_page.content).to have_header
  expect(taxpayer_details_page.content.input_field[0].input_label.text).to eq I18n.t('helpers.label.steps_details_taxpayer_individual_details_form.taxpayer_individual_first_name')
  expect(taxpayer_details_page.content.input_field[1].input_label.text).to eq I18n.t('helpers.label.steps_details_taxpayer_individual_details_form.taxpayer_individual_last_name')
  expect(taxpayer_details_page.content.input_field[2].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_address')
  expect(taxpayer_details_page.content.input_field[3].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_city')
  expect(taxpayer_details_page.content.input_field[4].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_postcode')
  expect(taxpayer_details_page.content.input_field[5].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_country')
  expect(taxpayer_details_page.content.input_field[6].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_email')
  expect(taxpayer_details_page.content.input_field[7].input_label.text).to eq I18n.t('dictionary.TAXPAYER_ADDRESS.taxpayer_contact_phone')
  taxpayer_details_page.submit_some_taxpayer_details
end

Then(/^I am shown an invalid email error$/) do
  expect(taxpayer_details_page.content.input_field[6].input_error.text).to have_text(I18n.t('dictionary.invalid_email'))
end

When(/^I re\-submit a valid email$/) do
  taxpayer_details_page.resubmit_valid_email
end