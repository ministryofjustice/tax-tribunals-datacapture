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


Then("I see the representative professional page") do
  expect(representative_professional_page.content).to have_representatives_header
end

Then("I should see the taxpayer_error") do
  expect(user_type_page.content.error).to have_error_heading
end

When("I click on the information dropdown") do
  user_type_page.representative_dropdown
end

Then("I shall see the what is a representative information") do
  expect(user_type_page.content).to have_representative_dropdown_content
end