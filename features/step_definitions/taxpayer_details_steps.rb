Given("I am on the taxpayer details page") do
  go_to_taxpayer_details_page
  expect(taxpayer_details_page.content).to have_header
end

When("I successfully submit taxpayers details") do
  expect(taxpayer_details_page.content.input_field[0].input_label.text).to eq 'First name'
  expect(taxpayer_details_page.content.input_field[1].input_label.text).to eq 'Last name'
  expect(taxpayer_details_page.content.input_field[2].input_label.text).to eq 'Address'
  expect(taxpayer_details_page.content.input_field[3].input_label.text).to eq 'City'
  expect(taxpayer_details_page.content.input_field[4].input_label.text).to eq 'Postcode'
  expect(taxpayer_details_page.content.input_field[5].input_label.text).to eq 'Country'
  expect(taxpayer_details_page.content.input_field[6].input_label.text).to eq 'Email address'
  expect(taxpayer_details_page.content.input_field[7].input_label.text).to eq 'Contact phone number (optional)'
  taxpayer_details_page.submit_taxpayer_details
end

Then("I am taken to representative page") do
  expect(representative_page).to be_displayed
  expect(representative_page.content).to have_header
end
