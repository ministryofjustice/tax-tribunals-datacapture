Given("I navigate to the has representative page") do
navigate_to_representative_page
end

When("I select nothing") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
  continue_or_save_continue
  end
end

Then("I see the selection error message") do
  expect(has_representative_page.content.error).to have_error_heading
end

Then("I see the grounds for appeal page") do
  expect(grounds_for_appeal_page.content).to have_header
end

Then("I see the representative professional status page") do
  expect(representative_professional_page.content).to have_individuals_header
end

Then("I am shown the no representative professional selection error") do
  expect(representative_professional_page.content.error).to have_error_heading
end

Then("I select that the representative is a solicitor") do
  representative_professional_page.submit_practising_solicitor
end

Then("I am taken to the representative type page") do
  expect(representative_type_page.content).to have_header
end


Then("I am shown the no representative selection error") do
  expect(representative_type_page.content.error).to have_error_heading
end

When("I select that the representative is an individual") do
representative_type_page.submit_individual
end

Then(/^I am taken to the representative details \(individual\) page$/) do
  expect(representative_details_page.content).to have_header
end

Then("I will see the pages error messages") do
  expect(representative_details_page.content).to have_input_error
end

When("I fill in the details and progress to the representative copy page") do
representative_details_page.submit_representative_details_with_email
#(ERROR NEED TO SEE IF ERROR MESSAGE IS REQ _ TO UPDATE)
#expect(representative_details_page.content).to have_input_error
#representative_details_page.add_email_and_submit
expect(send_representative_copy_page.content).to have_header

end

When("I select nothing and see the error messages") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
    continue_or_save_continue
    expect(send_representative_copy_page.content.error).to have_error_heading
  end
end

When("I press email and enter a invalid then valid email") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
    send_representative_copy_page.submit_email_and_a_invalid_email
    expect(send_representative_copy_page.content.error).to have_error_heading
    send_representative_copy_page.submit_email_and_a_valid_email
  end
end

When("I click the drop down information bar") do
  has_representative_page.representative_dropdown
end

Then("I will see the information provided") do
  expect(has_representative_page.content).to have_dropdown_content
end


When("I advance to the representative professional status page") do
  submit_yes
  expect(representative_professional_page.content).to have_individuals_header
end

And("I select that the representative is a tax agent") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
  representative_professional_page.submit_tax_agent
end
end

Then("I am taken to the authorise representative page") do
  expect(representative_approval_page.content).to have_header
end

When("I select the two information dropdowns") do
  representative_approval_page.authorise_representative_dropdown
  representative_approval_page.file_upload_dropdown
end

Then("I will see the additional information and move to the next page") do
  expect(representative_approval_page.content).to have_authorise_dropdown_content
  expect(representative_approval_page.content).to have_file_requirements_dropdown_content
  save_and_continue
  expect(representative_type_page.content).to have_header
end

When("I select that the representative is a company then that is 'other'") do
  representative_type_page.submit_company
  expect(representative_details_page.content).to have_header
  back
  representative_type_page.submit_other
  expect(representative_details_page.content).to have_header
end

When("I navigate to the authorise representative page") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
  submit_yes
  expect(representative_professional_page.content).to have_individuals_header
  representative_professional_page.submit_tax_agent
  expect(representative_approval_page.content).to have_header
  end
  end

And("I upload a file and continue to the representative type page") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
  identifier  = 'steps-details-representative-approval-form-representative-approval-document-field'
  filename    = 'features/support/sample_file/to_upload.jpg'
  representative_approval_page.attach_file(identifier, filename)
  continue_or_save_continue
    end
end

And("submit that my representation is other") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
  expect(representative_type_page.content).to have_header
  representative_type_page.submit_other
end
  end

Then(/^I am taken to the representative details page \(other\)$/) do
  expect(representative_details_page.content).to have_header
end

When(/^I enter an invalid non matching email address$/) do
  expect(send_representative_copy_page.content).to have_header
  send_representative_copy_page.submit_invalid_email
end

When(/^I enter a valid matching email address$/) do
  expect(send_representative_copy_page.content).to have_header
  send_representative_copy_page.submit_valid_email
end
