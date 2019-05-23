Given(/^I visit the homepage$/) do  
  home_page.load_page
end

When(/^I click the apply to close an enquiry link$/) do
  home_page.close_enquiry
end

Given("I should be asked what do you want to do") do
  expect(home_page.content).to have_header
end
