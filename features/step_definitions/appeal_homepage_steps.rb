Given(/^I am on the appeal homepage page$/) do
  appeal_homepage.load_page
end

When(/^I appeal against a tax decision$/) do
  appeal_homepage.appeal_decision
end

Then(/^I am taken to the appeal page$/) do
  expect(appeal_page).to be_displayed
  expect(appeal_page.content).to have_header
end
