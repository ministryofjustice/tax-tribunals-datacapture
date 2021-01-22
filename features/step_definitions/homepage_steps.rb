Given(/^I visit the homepage$/) do
  home_page.load_page
  expect(home_page.content).to have_header
end

When(/^I click the apply to close an enquiry link$/) do
  home_page.close_enquiry
end

Then("I should not see tax time information") do
  expect(home_page.content).to have_no_time_information_tax
end

Then("I should not see enquiry time information") do
  expect(home_page.content).to have_no_time_information_enquiry
end

When("I click the appeal a tax decision") do
  home_page.appeal
end

When("I click the return to a saved appeal button") do
  home_page.return
end

Then("I am taken to the login page") do
  expect(login_page.content).to have_header
end

When("I click the view guidance before I start link") do
  home_page.view_guidance
end

Then("I am taken to the guidance page") do
  expect(guidance_page.content).to have_header
end
