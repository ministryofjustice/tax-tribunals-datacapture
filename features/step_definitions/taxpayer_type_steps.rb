Then("I am taken to the taxpayer type page") do
  expect(taxpayer_type_page.content).to have_closure_header
end

Given("I am on the taxpayer type page") do
  navigate_to_closure_taxpayer_type_page
end

Given("I am taken to the taxpayer details page") do
  expect(taxpayer_details_page.content).to have_header
end
