Given("I navigate to closure user type page") do
  navigate_to_closure_user_type_page
  expect(user_type_page.content).to have_closure_header
end

When("I submit that I am the tax payer making the application") do
  submit_yes
  expect(taxpayer_type_page.content).to have_closure_header
end

When("I submit that I am not the tax payer making the application") do
  submit_no
  expect(representative_professional_page.content).to have_header
end