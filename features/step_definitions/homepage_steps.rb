Given(/^I visit the homepage$/) do
  home_page.load_page
  expect(home_page.content).to have_header
end

When(/^I click the apply to close an enquiry link$/) do
  home_page.close_enquiry
end

Then("I am taken to the closure page") do
  expect(closure_page.content).to have_header
end

When("I click the appeal a tax decision") do
  home_page.appeal
end

Then("I am taken to the appeal page") do
  expect(appeal_page.content).to have_header
end

Then("I should not see tax time information") do
  expect(home_page.content).to have_no_time_information_tax
end

Then("I should not see enquiry time information") do
  expect(home_page.content).to have_no_time_information_enquiry
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

When("I click on the '{word}' link") do |language|
  click_link(language)
end

Then("I am on the '{word}' locale") do |locale|
  expect(page).to have_current_path(local_root_path(locale: locale))
end

When("I select language link") do
  click_link(I18n.t('selector.language'))
end

Then("I will see the website open in that language") do
  locale = current_path.split('/')[1]
  if ENV['TEST_LOCALE'] == 'cy'
    expect(locale).to eq('en')
  else
    expect(locale).to eq('cy')
  end
end
