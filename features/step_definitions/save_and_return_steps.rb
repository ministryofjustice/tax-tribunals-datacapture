Given("I sign in using my sign in details") do
  go_to_login_page
  user = FactoryBot.create(:user)
  login_page.content.email_input.set user.email
  login_page.content.password_input.set user.password
  login_page.content.sign_in_button.click
  expect(page).not_to have_content "There's an error. Please enter a valid email and password."
end

Given("I create an account in appeal journey") do
  expect(save_return_page.content).to have_header
  save_return_page.content.create_account_checkbox.click
  continue
  expect(save_appeal_page.content).to have_appeal_header
  save_appeal_page.content.email_input.set 'test@email.net'
  save_appeal_page.content.password_input.set 'TaxTribun4!'
  save
end

Given("I create an account in closure journey") do
  expect(save_return_page.content).to have_header
  save_return_page.content.create_account_checkbox.click
  continue
  expect(save_appeal_page.content).to have_closure_header
  save_appeal_page.content.email_input.set 'test@email.net'
  save_appeal_page.content.password_input.set 'TaxTribun4!'
  save
end

When("I click on continue when I am on the save confirmation page") do
  expect(save_confirmation_page.content).to have_header
  save_confirmation_page.content.continue_button.click
end

Then("I should be on the closure user type page") do
  expect(user_type_page.content).to have_closure_header
end

Then("I should be on the appeal user type page") do
  expect(user_type_page.content).to have_appeal_header
end
