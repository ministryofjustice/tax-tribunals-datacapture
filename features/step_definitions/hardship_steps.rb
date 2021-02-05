Given("I am taken to the disputed tax paid step") do
  navigate_to_disputed_tax_paid_page
end

When("I submit that I have not paid the tax under dispute") do
  submit_no
  expect(hardship_review_requested_page.content).to have_header
end

When("I submit that I have asked HMRC if I could appeal to tribunal") do
  submit_yes
  expect(hardship_review_status_page.content).to have_header
end

When("I submit that HMRC did not allow me to defer paying") do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    submit_no
    expect(hardship_reason_page.content).to have_header
  end
end

When("I submit a reason for financial hardship") do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    hardship_reason_page.submit_reason
  end
end

Then("I am on in time page") do
  expect(in_time_page.content).to have_header
end
