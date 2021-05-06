Given("I navigate to closure user type page") do
  navigate_to_closure_user_type_page
  expect(user_type_page.content).to have_closure_header
end

When("I submit that I am the tax payer making the application") do
  if ENV['TEST_LOCALE'] == 'cy'
    submit_yes_2
  else
    submit_yes
  end
  expect(taxpayer_type_page.content).to have_closure_header
end

When("I submit that I am not the tax payer making the application") do
  if ENV['TEST_LOCALE'] == 'cy'
    submit_no_welsh_2
  else
    submit_no
  end
end