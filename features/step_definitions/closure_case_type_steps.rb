Given("I am on the closure case type page") do
  navigate_to_closure_case_type_page
end

Then("I should see that I can only close one of the listed options") do
  expect(closure_case_type_page.content).to have_one_on_list
end

When("I submit that it is a personal return") do
  closure_case_type_page.submit_personal_return
end

When("I press continue with nothing selected") do
  continue_or_save_continue
end

Then("The error should appear") do
  expect(closure_case_type_page.content).to have_content("There is a problem")
end

When(/^I submit that it is a company return$/) do
  closure_case_type_page.submit_company_return
end

When(/^I submit that it is a partnership return$/) do
  closure_case_type_page.submit_partnership_return
end

When(/^I submit that it is a trustee return$/) do
  closure_case_type_page.submit_trustee_return
end

When(/^I submit that it is an enterprise management incentive \(EMI\)$/) do
  closure_case_type_page.submit_enterprise_mgmt_incentives
end

When(/^I submit that is is a non\-resident Capital Gains Tax \(NRCGT\) return$/) do
  closure_case_type_page.submit_non_resident_capital_gains_tax
end

When(/^I submit that it is a Stamp Duty Land Tax \(SDLT\) or Land Transaction Tax \(in Wales\): land transaction return$/) do
  closure_case_type_page.submit_stamp_duty_land_tax_return
end

When(/^I submit that is a Transactions in securities: issue of counteraction or no\-counteraction notice$/) do
  closure_case_type_page.submit_transactions_in_securities
end

When(/^I submit that is a Claim or amendment of a claim$/) do
  closure_case_type_page.submit_claim_or_amendment
end

Then(/^I should see a 'Select the type of enquiry you want to close' error$/) do
  expect(appeal_case_type_page).to have_text("Select the type of enquiry you want to close")
end