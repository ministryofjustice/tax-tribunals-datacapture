Given("I navigate to the has grounds for appeal page") do
  navigate_to_grounds_for_appeal_page
end

When("I press continue with nothing entered") do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
  continue_or_save_continue
  end
  end

Then("I should see the empty page error") do
  expect(grounds_for_appeal_page.content.error_summary).to have_error_heading
end

When("I submit a response with text entered") do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
  grounds_for_appeal_page.valid_submission
  end
  end

Then("I can navigate to the details-pathway eu exit page") do
  expect(eu_exit_page('details').content).to have_header
end

When(/^I then upload a valid file type$/) do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
  identifier  = 'steps-details-grounds-for-appeal-form-grounds-for-appeal-document-field'
  filename    = 'features/support/sample_file/to_upload.jpg'
  grounds_for_appeal_page.attach_file(identifier, filename)
  continue_or_save_continue
  end
  end

When("I select 'File upload requirements'") do
  grounds_for_appeal_page.file_upload_requirements
end

Then("I will see the file requirements") do
  expect(grounds_for_appeal_page.content).to have_file_information
end

Then("I am on the outcome page") do
  expect(outcome_page.content).to have_header
end

When("I submit no and then yes") do
  submit_no
  expect(outcome_page.content).to have_header
  back
  submit_yes
  expect(outcome_page.content).to have_header
end

When("I complete a blank then valid submission") do
  continue_or_save_continue
  expect(outcome_page.content.error).to have_error_heading
  outcome_page.valid_submission
end

Then("I am on the need support page") do
    expect(need_support_page.content).to have_header
end

When("I submit no support needed") do
  submit_no
end


When("I submit yes") do
  submit_yes
end

Then("I should be on the what support page") do
  expect(what_support_page.content).to have_header
end

Then("I should see the support selection error") do
  expect(need_support_page.content.error).to have_error_heading
end

When("I complete a valid submission") do
  outcome_page.valid_submission
end