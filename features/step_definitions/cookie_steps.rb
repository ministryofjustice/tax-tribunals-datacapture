Then("I see the cookie banner is present") do
  expect(home_page.cookie).to have_header
  expect(home_page.cookie).to have_accept_button
  expect(home_page.cookie).to have_reject_button
end

When("I accept the cookies") do
  home_page.cookie.accept_button.click
end

When("I reject the cookies") do
  home_page.cookie.reject_button.click
end

Then("I see the cookie banner is not present") do
  expect(home_page.cookie).to have_no_header
end

And("I click save settings") do
  cookie_page.content.save_cookies.click
  expect(cookie_page).to have_success
end