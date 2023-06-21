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
