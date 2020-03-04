Given("I am on the taxpayer details page") do
  taxpayer_details_page.go_to_taxpayer_details_page
  expect(taxpayer_details_page.content).to have_header
end

When("I successfully submit taxpayers details") do
  expect(taxpayer_details_page.content.input_field[0].input_label.text).to eq 'First name'
  taxpayer_details_page.content.input_field[0].first_name_input.set 'John'
  expect(taxpayer_details_page.content.input_field[1].input_label.text).to eq 'Last name'
  taxpayer_details_page.content.input_field[1].last_name_input.set 'Smith'
  expect(taxpayer_details_page.content.input_field[2].input_label.text).to eq 'Address'
  taxpayer_details_page.content.input_field[2].address_input.set '102 Petty France'
  expect(taxpayer_details_page.content.input_field[3].input_label.text).to eq 'City'
  taxpayer_details_page.content.input_field[3].city_input.set 'London'
  expect(taxpayer_details_page.content.input_field[4].input_label.text).to eq 'Postcode'
  taxpayer_details_page.content.input_field[4].postcode_input.set 'SW1H 9AJ'
  expect(taxpayer_details_page.content.input_field[5].input_label.text).to eq 'Country'
  taxpayer_details_page.content.input_field[5].country_input.set 'UK'
  expect(taxpayer_details_page.content.input_field[6].input_label.text).to eq 'Email address'
  taxpayer_details_page.content.input_field[6].email_input.set 'jsmith_test@test.com'
  expect(taxpayer_details_page.content.input_field[7].input_label.text).to eq 'Contact phone number (optional)'
  taxpayer_details_page.content.input_field[7].phone_input.set '07777 888888'
  continue
end

Then("I am taken to representative page") do
  expect(current_path).to eq '/steps/details/has_representative'
end
