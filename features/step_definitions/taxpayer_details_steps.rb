Given("I navigate to the closure taxpayer details page as a taxpayer") do
  navigate_to_closure_taxpayer_details_page(:taxpayer_user_type)
end

Given("I navigate to the closure taxpayer details page as a representative") do
  navigate_to_closure_taxpayer_details_page(:representative_user_type)
end

When("I successfully submit taxpayers details") do
  expect(taxpayer_details_page.content).to have_header
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

When("I submit a blank taxpayers details form") do
  expect(taxpayer_details_page.content).to have_header
  continue_or_save_continue
end

Then("I am taken to the send taxpayer copy page") do
  expect(send_taxpayer_copy_page.content).to have_header
end

Then("I am shown all the taxpayer details errors") do
  expect(taxpayer_details_page.content.input_field[0].input_error.text).to have_content(/Please enter a first name/)
  expect(taxpayer_details_page.content.input_field[1].input_error.text).to have_content(/Please enter a last name/)
  expect(taxpayer_details_page.content.input_field[2].input_error.text).to have_content(/Please enter an address/)
  expect(taxpayer_details_page.content.input_field[3].input_error.text).to have_content(/Please enter a city/)
  expect(taxpayer_details_page.content.input_field[4].input_error.text).to have_content(/Please enter a postcode/)
  expect(taxpayer_details_page.content.input_field[5].input_error.text).to have_content(/Please enter a country/)
  expect(taxpayer_details_page.content.input_field[6].input_error.text).to have_content(/Please enter your email address/)
end

Then("I am on the taxpayer details page") do
  expect(taxpayer_details_page.content).to have_header
end
