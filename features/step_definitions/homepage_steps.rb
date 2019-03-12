Given(/^I visit the homepage$/) do
  homepage_page.load_page
end

When(/^I click the apply to close an enquiry link$/) do
  homepage_page.close_enquiry
end
