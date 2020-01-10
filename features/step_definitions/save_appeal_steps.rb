Given("I have an appeal in progress") do
  home_page.load_page
  home_page.appeal
  appeal_home_page.continue
  appeal_case_type_page.submit_income_tax
end

When("I click on save and come back later") do
  challenge_decision_page.save_and_come_back
end

Then("I am taken to the save your appeal page") do
  expect(save_appeal_page.content).to have_header
  expect(save_appeal_page).to be_displayed
end

When("I enter a password that is not at least 8 characters") do
  expect(save_appeal_page.content).to have_choose_password
  save_appeal_page.content.password_input.set 'save'
  save
end

Then("I should see an error messages telling me the criteria has not been met") do
  expect(save_appeal_page.content).to have_password_error
end
