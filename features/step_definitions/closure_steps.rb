Given(/^I am on the closure page$/) do
  go_to_closure_page
  expect(closure_page.content).to have_header
  expect(closure_page).to be_displayed
end

When(/^I click continue to close an enquiry$/) do
  closure_page.continue
end