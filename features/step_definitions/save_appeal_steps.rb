Given("I have an appeal in progress") do
  home_page.load_page
  home_page.appeal
  appeal_home_page.continue
  appeal_case_type_page.submit_income_tax
  expect(save_return_page.content).to have_header
  continue
  expect(challenge_decision_page.content).to have_header
end

When("I click on save and come back later") do
  challenge_decision_page.save_and_come_back
end

Then("I am taken to the save your appeal page") do
  expect(save_appeal_page.content).to have_appeal_header
  expect(save_appeal_page).to be_displayed
end

When("I enter a valid email address") do
  expect(save_appeal_page.content.login_label[0].text).to eq 'Your email address'
  save_appeal_page.content.email_input.set Faker::Internet.email
end

When("I enter a password that is not at least 8 characters") do
  expect(save_appeal_page.content.login_label[1].text).to eq 'Choose password'
  save_appeal_page.content.password_input.set 'Pa$0'
  save
end

When("I enter a password that does not have at least one number") do
  save_appeal_page.content.password_input.set 'Pa$$word'
  save
end

When("I enter a password that does not have an upper and lower case") do
  save_appeal_page.content.password_input.set 'pa$$word2020'
  save
end

When("I enter a password that does not have a special character") do
  save_appeal_page.content.password_input.set 'password2020'
  save
end

When("I enter a password that is the same as my email address") do
  save_appeal_page.content.password_input.set 'test@test.com'
  save
end

And("I enter a valid password") do
  save_appeal_page.content.password_input.set '$%BjTvZjB0'
  save
end

Then("I should see a password error messages") do
  expect(save_appeal_page.content).to have_error_message
end

Then("I should be taken to the saved confirmation page") do
  expect(current_url).to end_with '/registration/save_confirmation'
end
