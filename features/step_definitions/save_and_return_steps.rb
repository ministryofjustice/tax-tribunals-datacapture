Given("I create an account in appeal journey") do
  expect(save_return_page.content).to have_header
  save_return_page.content.create_account_checkbox.click
  continue_or_save_continue
  expect(save_appeal_page.content).to have_appeal_header
  save_appeal_page.content.email_input.set 'test_tt@hmcts.net'
  save_appeal_page.content.password_input.set 'TaxTribun4!'
  save
end

Given("I create an account in closure journey") do
  expect(save_return_page.content).to have_header
  save_return_page.content.create_account_checkbox.click
  continue_or_save_continue
  expect(save_appeal_page.content).to have_closure_header
  save_appeal_page.content.email_input.set 'test_tt@hmcts.net'
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

Given("I am on the closure case type page without login") do
  closure_case_type_page.load_page
end
