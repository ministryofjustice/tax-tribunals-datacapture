Given("I navigate to the login page") do
  go_to_login_page
end

Given("I click sign in") do
  login_page.click_sign_in
end

Then("I should see a blank email error message") do
  expect(login_page.content.error_summary).to have_blank_email_error
end

Then("I should see a blank password error message") do
  expect(login_page.content.error_summary).to have_blank_password_error
end

Then("I should see an invalid email and password error message") do
  expect(login_page.content.error_summary).to have_invalid_error
end

Then("I should not have logged in") do
  expect(login_page.content).to have_header
  expect(page).not_to have_text 'Sign out'
end

Given("I fill in invalid log in details") do
  login_page.invalid_sign_in
end

When(/^I click the 'Forgot your password\?' link$/) do
  click_link('Forgot your password?')
end

Then(/^I will be on the 'Forgot your password' page$/) do
  expect(page).to have_text("Forgot your password")
end

When(/^I click the reset button password without an email$/) do
  click_button 'Reset password'
end

Then(/^I will see a blank email error message$/) do
  expect(page).to have_text("Please enter your email address")
end

When(/^I click the go back link$/) do
  click_link('Go back and sign in')
end