# See `dropzone_helpers.rb` for the step relating to checkboxes and a comment
# explaining why that step is there.

Then(/^I should be on "([^"]*)"$/) do |page_name|
  expect(current_url).to eq page_name
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_text(text)
end

Then(/^I should not see "(.*?)"$/) do |text|
  expect(page).not_to have_text(text)
end

Then(/^I should not see dropzone errors$/) do
  expect(page).not_to have_text("format we don't accept")
  expect(page).not_to have_text("Server responded with 0 code")
  expect(page).not_to have_text("No files uploaded")
end

When(/^I click the "(.*?)" link$/) do |text|
  click_link(text)
end

When(/^I click continue$/) do
  base_page.continue
end
  
When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

When(/^I successfully save my appeal$/) do
  save_appeal_page.succesfully_save_appeal
end

# I couldn't click the radio button using 'choose(text)', so just
# click the label with matching text - that should have the same
# effect
When(/^I click the radio button "([^"]*)"$/) do |text|
  find('label', text: text).click
end

When(/^I choose "([^"]*)"$/) do |text|
  step %[I click the radio button "#{text}"]
  find('[name=commit]').click
end

Then(/^I see a case reference number$/) do
  expect(page).to have_text(/TC\/#{Date.today.year}\/\d{5}/)
end

When(/^I pause for "([^"]*)" seconds$/) do |seconds|
  sleep seconds.to_i
end

Given(/^I fill in taxpayers details$/) do
  taxpayer_details_page.successfully_submit_taxpayer_details
end

And(/^I save and continue$/) do
  base_page.save_and_continue
end

And(/^I continue$/) do
  base_page.continue
end

Given(/^I successfully submit enquiry details$/) do
  enquiry_details_page.successfully_submit_enquiry_details
end

Then(/^I should be taken to my cases$/) do
  expect(cases_page).to be_displayed
  expect(cases_page.content).to have_header
end

When(/^I click the resume button$/) do
  cases_page.resume.click
end

Then(/^I should be taken to dispute type page$/) do
  expect(dispute_type_page.content).to have_header
  expect(dispute_type_page).to be_displayed
end

Given(/^I fill in my reason$/) do
  additional_info_page.provide_reason
end

Then(/^I should be taken to additional info on why the enquiry should be closed$/) do
  expect(additional_info_page.content).to have_header
  expect(additional_info_page).to be_displayed
end
