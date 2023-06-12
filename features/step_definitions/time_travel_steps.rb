When(/^I wait for (\d+) minutes$/) do |arg|
  travel arg.minutes
end

Then(/^I will see the invalid session timeout error$/) do
  expect(page).to have_text "Sorry, you'll have to start again"
end

And(/^I will not see the invalid timeout error$/) do
  expect(page).not_to have_text "Sorry, you'll have to start again"
end