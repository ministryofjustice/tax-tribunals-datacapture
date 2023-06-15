
Given("I visit the in time page") do
  navigate_to_the_in_time_page
end

Then("I see the selection error") do
  expect(in_time_page.content.error).to have_error_heading
end

When("I choose that i am in time") do
  in_time_page.submit_yes
end

Then("I am taken to the user type page") do
  expect(user_type_page.content).to have_appeal_header
end

When("I select that i am not in time") do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    allow(Uploader).to receive(:add_file).and_return(double(name: '123/foo/bar.png'))
  in_time_page.submit_no
    end
end

Then("I am taken to the lateness reason page") do
  expect(lateness_reason_page.content).to have_header
end

When("I choose the file requirements dropdown") do
  lateness_reason_page.file_upload_dropdown
end

Then("I see the dropdown information") do
  expect(lateness_reason_page.content).to have_file_requirements_dropdown_content
end

Then("I see the submission error message") do
  expect(lateness_reason_page.content.error).to have_error_heading
end

When("I enter a valid reason") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
    lateness_reason_page.valid_submission
  end
end

When("I select that I am not sure") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
  in_time_page.submit_not_sure
  end
  end

Then("I am taken to the reasons page") do
  expect(lateness_reason_page.content).to have_not_sure_header
end

When(/^I click continue$/) do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
    continue_or_save_continue
  end
end
