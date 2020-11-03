Given(/^I am on the appeal homepage page$/) do
  appeal_home_page.load_page
end

When(/^I appeal against a tax decision$/) do
  appeal_home_page.continue
end

Then(/^I am taken to the appeal case type page$/) do
  expect(appeal_case_type_page).to be_displayed
  expect(appeal_case_type_page.content).to have_header
end

Then("I am taken to the appeal page") do
  expect(appeal_home_page.content).to have_header
end
