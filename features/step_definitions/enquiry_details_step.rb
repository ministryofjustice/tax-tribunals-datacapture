Given("I am on the enquiry details page") do
  navigate_to_enquiry_details_page
  expect(enquiry_details_page.content).to have_header
end

When("I fill in the two required fields and submit") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
    enquiry_details_page.valid_submission
  end
end

Then("I should be on the additional info page") do
  expect(additional_info_page.content).to have_header
end

Then("I should see two enquiry details errors") do
  expect(enquiry_details_page.content.error_summary).to have_reference_number_error
  expect(enquiry_details_page.content.error_summary).to have_years_error
end

When(/^I upload a virus document to the additional info page$/) do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
    identifier  = 'steps-closure-additional-info-form-closure-additional-info-document-field'
    filename    = 'features/support/sample_file/clamav-test-virus.jpg'
    additional_info_page.attach_file(identifier, filename)
  end
end


Then(/^I will see a virus upload error on the additional info page$/) do
  expect(additional_info_page.content).to have_header
  expect(additional_info_page.content.error).to have_error_heading
end