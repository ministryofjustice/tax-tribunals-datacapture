Given("I am on the challenge decision page") do
  navigate_to_challenge_decision_page
end

When("I continue with no option selected") do
  continue_or_save_continue
end

Then("I see the problem error message") do
  expect(challenge_decision_page.content.error).to have_error_heading
end

And("I am still on the challenge decision page") do
  expect(challenge_decision_page.content).to have_appeal_header
end

When("I select yes") do
  submit_yes
  end

Then("I am taken to the challenge decision status page") do
  expect(challenge_decision_status_page.content).to have_header
end

When("I select no") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
  submit_no
  end
  end

Then("I am taken to the must appeal decision status page") do
  expect(page).to have_text 'You must appeal the original decision to HMRC'
end

When("I press 'Help with challenging a decision'") do
  challenge_decision_page.help_with_challenging_dropdown
end

Then("I will see the drop down list") do
  expect(challenge_decision_page.content).to have_dropdown_content
end

When("I press 'challenge a tax decision with HM Revenue and Customs'") do
  challenge_decision_page.challenging_decision_HMRC
end

Then("I will be on the gov 'tax-appeals' page") do
  expect(page).to have_text "Disagree with a tax decision"
end

When("I press 'options when UK border force seizes your things'") do
  challenge_decision_page.border_force
end

Then("I will be on the gov 'customs-seizures' page") do
  expect(page).to have_text "Options when customs seizes your things"
end

And("I press how to 'challenge a national crime agency'") do
  challenge_decision_page.nca
end

Then("I will be on the appeal home page") do
  expect(page).to have_text "Appeal to the tax tribunal"
end

When("I press continue with no response selected") do
  continue_or_save_continue
end

Then("I will see the error response") do
  expect(challenge_decision_status_page.content.error).to have_error_heading
end

And("I will still be on the decision status page") do
  expect(challenge_decision_status_page.content).to have_header
end

When("I select I have a review conclusion letter") do
  challenge_decision_status_page.submit_review_letter
end

Then("I should be on the dispute type page") do
  expect(dispute_type_page.content).to have_header
end

When(/^I select waiting for more than fourty five days$/) do |arg|
  challenge_decision_status_page.more_than_fourtyfive
end

When(/^I am appealing to TT directly$/) do
  challenge_decision_status_page.direct
end

When(/^I select I was offered a review$/) do
  challenge_decision_status_page.review
end

When("I select I have been waiting less than fourty five days") do
  challenge_decision_status_page.submit_less_than_fourty_five_days
end

Then("I should be taken to the must wait for challenge decision page") do
  expect(page).to have_text "You must wait before you can appeal"
end

When("I select my appeal to HMRC was late") do
  challenge_decision_status_page.late_appeal
end

Then("I am taken to the are you in time page") do
  expect(in_time_page.content).to have_header
end

When(/^I select I have been waiting for fourty five days or more for a review to finish$/) do
  challenge_decision_status_page.more_than_fourtyfive
end

When(/^I select I am appealing direct to the tribunal before receiving a response from HMRC$/) do
  challenge_decision_status_page.direct
end