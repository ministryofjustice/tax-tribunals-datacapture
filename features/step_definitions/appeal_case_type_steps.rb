Given("I am on the appeal case type page") do
  appeal_home_page.load_page
  expect(appeal_home_page).to be_displayed
  appeal_home_page.continue
  expect(appeal_case_type_page).to be_displayed
end

When("I click on continue without selecting a case type") do
  continue
end

Then("I should see error message") do
  expect(appeal_case_type_page.content.error).to have_error_heading
  expect(appeal_case_type_page.content.error).to have_error_link
end

When("I click on continue after selecting Income Tax option") do
  appeal_case_type_page.content.income_tax_option.click
  continue
end

Then("I should go to the challenge decision page") do
  expect(challenge_decision_page).to be_displayed
end

When("I click on continue after selecting Other option") do
  appeal_case_type_page.content.other_option.click
  continue
end

Then("I should go to the case type show more page") do
  expect(appeal_case_type_show_more_page).to be_displayed
end

When("I am on the case type show more page") do
  expect(appeal_case_type_show_more_page).to be_displayed
end

When("I click on continue after selecting capital gains option") do
  appeal_case_type_page.content.capital_gains_option.click
  continue
end

Then("I should be on the appeal case type page") do
  expect(appeal_case_type_page).to be_displayed
end

Then("I should see answer error message") do
  expect(appeal_case_type_show_more_page.content.error).to have_answer_error_heading
  expect(appeal_case_type_show_more_page.content.error).to have_answer_error_link
end

When("I click on None of the above option") do
  appeal_case_type_show_more_page.content.none_of_above_option.click
end

When("I click on continue without providing an answer") do
  continue
end

When("I click on continue after providing an answer") do
  appeal_case_type_show_more_page.content.none_of_above_answer_box.set 'Reason'
  continue
end

When("I click on continue after selecting Aggregates Levy option") do
  appeal_case_type_show_more_page.content.aggregates_levy_option.click
  continue
end

Then("I should go to the in time page") do
  expect(page).to have_current_path('/steps/lateness/in_time')
end
