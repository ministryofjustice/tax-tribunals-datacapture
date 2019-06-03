Then("I am taken to the user type page") do
  expect(user_type_page).to be_displayed
  expect(user_type_page.content).to have_header
end

Given("I am on the user type page") do
  user_type_page.go_to_user_type_page
  expect(user_type_page).to be_displayed
  expect(user_type_page.content).to have_header
end

When("I submit that I am the tax payer making the application") do
  user_type_page.submit_yes
end
