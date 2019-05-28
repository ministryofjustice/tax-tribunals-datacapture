Then("I am taken to the taxpayer type page") do
  expect(taxpayer_type_page).to be_displayed
  expect(taxpayer_type_page.content).to have_header
end

Given("I am on the taxpayer type page") do
  taxpayer_type_page.go_to_taxpayer_type_page
  expect(taxpayer_type_page).to be_displayed
  expect(taxpayer_type_page.content).to have_header
end

Given("I am taken to the taxpayer details page") do
  expect(taxpayer_details_page).to be_displayed
end
