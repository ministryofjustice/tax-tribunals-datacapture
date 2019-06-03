Given("I am on the appeal case type page") do
  appeal_home_page.load_page
  appeal_home_page.continue
end

When("I click on continue without selecting a case type") do
  continue
end

Then("I should see error message") do
  expect(appeal_case_type_page.content.error).to have_error_heading
  expect(appeal_case_type_page.content.error).to have_error_link
end

