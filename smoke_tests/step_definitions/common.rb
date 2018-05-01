# See `dropzone_helpers.rb` for the step relating to checkboxes and a comment
# explaining why that step is there.

Given(/^I show my environment$/) do
  puts "Running against: #{ENV.fetch('DATACAPTURE_URI')}"
end

When(/^I visit "(.*?)"$/) do |path|
  visit path
end

Then(/^I should be on "([^"]*)"$/) do |page_name|
  expect("#{Capybara.app_host}#{URI.parse(current_url).path}").to eql("#{Capybara.app_host}#{page_name}")
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

When(/^I click the "(.*?)" button$/) do |text|
  begin
    find("input[value='#{text}']").click
  rescue Capybara::Poltergeist::MouseEventFailed
    find("input[value='#{text}']").trigger('click')
  end
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
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

Given(/^I fill in my email address$/) do
  @email ||= "#{SecureRandom.uuid}@test.com"
  puts @email
  step %[I fill in "Your email address" with "#{@email}"]
end

When(/^I pause for "([^"]*)" seconds$/) do |seconds|
  sleep seconds.to_i
end

Given(/^I fill the contact details$/) do
  step 'I fill in "First name" with "MoJ Digital"'
  step 'I fill in "Last name" with "Smoketest"'
  step 'I fill in "Address" with "102 Petty France"'
  step 'I fill in "City" with "London"'
  step 'I fill in "Postcode" with "SW1H 9AJ"'
  step 'I fill in "Country" with "UK"'
  step 'I fill in "Email address" with "do-not-email@digital.justice.gov"'
end

Then(/^I should see the reference "([^"]*)" on page$/) do |text|
  expect(page).to have_text(text)
end

When(/^I click on the "([^"]*)" link$/) do |arg1|
  find('a.button').click
end

When(/^I accept alert$/) do
  page.evaluate_script('window.confrim = function() {return true;}')
end

Then(/^I should not see pending application$/) do
  within(:css, 'tr') do
    expect(page).not_to have_selector(:css, "input[value='Delete']")
    expect(page).not_to have_selector(:css, 'a.button.ga-pageLink')
    expect(page).not_to have_link(:linktext, 'Edit reference')
  end
end

When(/^I click Continue without selecting an option$/) do
  step 'I click the "Continue" button'
end

Then(/^I should get an error message "([^"]*)"$/) do |text|
  within 'div.error-summary' do
    expect(page).to have_text(text)
  end
end

When(/^I am on review of original decision page$/) do
  step 'I choose "Income Tax"'
end

When(/^I am on What response did you receive page$/) do
  step 'I choose "Income Tax"'
  step 'I choose "Yes"'
end

When(/^I am on dispute type page$/) do
  step 'I choose "Income Tax"'
  step 'I choose "Yes"'
  step 'I choose "I have a review conclusion letter"'
end

When(/^I am on the penalty or surcharge amount page$/) do
  step 'I choose "Income Tax"'
  step 'I choose "Yes"'
  step 'I choose "I have a review conclusion letter"'
  step 'I choose "Penalty or surcharge"'
end

When(/^I am on Are you in time to appeal to the tax tribunal page$/) do
  step 'I choose "Income Tax"'
  step 'I choose "Yes"'
  step 'I choose "I have a review conclusion letter"'
  step 'I choose "Penalty or surcharge"'
  step 'I choose "£100 or less"'
end

When(/^I am on Are you the taxpayer making the appeal page$/) do
  step 'I choose "Income Tax"'
  step 'I choose "Yes"'
  step 'I choose "I have a review conclusion letter"'
  step 'I choose "Penalty or surcharge"'
  step 'I choose "£100 or less"'
  step 'I choose "Yes, I am in time"'
end

When(/^I am on Who is making the appeal page$/) do
  step 'I choose "Income Tax"'
  step 'I choose "Yes"'
  step 'I choose "I have a review conclusion letter"'
  step 'I choose "Penalty or surcharge"'
  step 'I choose "£100 or less"'
  step 'I choose "Yes, I am in time"'
  step 'I choose "Yes"'
end
