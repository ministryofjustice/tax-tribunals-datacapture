When("I dont select a dispute type") do
  continue_or_save_continue
end

Then("I should see the no selection error") do
  expect(dispute_type_page.content.error).to have_error_heading
end

Then("I should see an enter penalty amount error") do
  expect(penalty_amount_page.content.error_summary).to have_enter_penalty_error
end

Then("I should see a penalty amount too small error") do
  expect(penalty_amount_page.content.error_summary).to have_amount_too_small_error
end

Then("I should see a penalty amount too large error") do
  expect(penalty_amount_page.content.error_summary).to have_amount_too_large_error
end

Given("I am on the dispute type page") do
  navigate_to_dispute_type_page(:income_tax_case)
  expect(dispute_type_page.content).to have_header
end

Given("I am on the dispute type page through vat") do
  navigate_to_dispute_type_page(:vat_case)
  expect(dispute_type_page.content).to have_header
end

Given("I click the penalty or surcharge option and submit") do
  dispute_type_page.submit_penalty_or_surcharge
  expect(penalty_amount_page.content).to have_header
end

Then("I should see a select penalty or surcharge amount error") do
  expect(penalty_amount_page.content).to have_header
  expect(penalty_amount_page.content.error_summary).to have_select_option_error
end

When("I select 100 to 20000 option and submit") do
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_invalid_100_to_20000
end

When("I input too small an amount") do
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_too_small_100_to_20000
end

When("I input too large an amount") do
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_too_large_100_to_20000
end

When("I submit a penalty amount value") do
  expect(penalty_amount_page.content).to have_header
  penalty_amount_page.submit_valid_100_to_20000
end

Given("I click HMRC repay option and submit") do
  dispute_type_page.submit_repay_option
  expect(tax_amount_page.content).to have_header
end

Given("I click owe money and a penalty or surcharge option and submit") do
  dispute_type_page.submit_owe_and_penalty_option
end

Given("I click PAYE option and submit") do
  dispute_type_page.submit_paye_option
end

Given("I click none of the above option and submit") do
  dispute_type_page.submit_invalid_nota_option
end

Then("I should see please enter an answer error") do
  expect(dispute_type_page.content).to have_enter_answer_error
end

When("I submit what my dispute is about") do
  dispute_type_page.submit_valid_nota_option
end

Then("I should see an enter the tax amount error") do
  expect(tax_amount_page.content.error_summary).to have_enter_tax_amount_error
  expect(tax_amount_page.content).to have_header
end

When("I submit a tax amount value") do
  expect(tax_amount_page.content).to have_header
  tax_amount_page.valid_submission
end

Then("I should see two penalty and tax amount errors") do
  expect(penalty_and_tax_amounts_page.content.error_summary).to have_enter_tax_amount_error
  expect(penalty_and_tax_amounts_page.content.error_summary).to have_enter_penalty_amount_error
end

When("I submit both tax and penalty amount values") do
  penalty_and_tax_amounts_page.valid_submission
end

Given("I click notice of requirement option and submit") do
  dispute_type_page.submit_notice_of_requirement_option
end

Given("I click registration option and submit") do
  dispute_type_page.submit_registration_option
end

