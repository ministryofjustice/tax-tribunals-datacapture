Then("I am taken to the case type case") do
  expect(case_type_page).to be_displayed
  expect(case_type_page.content).to have_header
end

Given("I am on the case type page") do
  case_type_page.go_to_case_type_page
  expect(case_type_page).to be_displayed
  expect(case_type_page.content).to have_header
end

Then("I should see that I can only close one of the listed options") do
  expect(case_type_page.content).to have_one_on_list
end

When("I submit that it is a personal return") do
  case_type_page.submit_personal_return
end
