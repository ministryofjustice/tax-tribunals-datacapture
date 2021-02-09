When("I submit that I have not paid the tax under dispute") do
  expect(disputed_tax_paid_page.content).to have_header
  submit_no
  expect(hardship_review_requested_page.content).to have_header
end

When("I submit that I have paid the tax under dispute") do
  expect(disputed_tax_paid_page.content).to have_header
  submit_yes
end

When("I submit that I have asked HMRC if I could appeal to tribunal") do
  submit_yes
end

When("I submit that I have not asked HMRC if I could appeal to tribunal") do
  expect(hardship_review_requested_page.content).to have_header
  submit_no
end

When("I submit that HMRC did not allow me to defer paying") do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    submit_no
    expect(hardship_reason_page.content).to have_header
  end
end


When("I submit that HMRC did allow me to defer paying") do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    submit_yes
  end
end

When("I submit a reason for financial hardship") do
  RSpec::Mocks.with_temporary_scope do
    allow(Uploader).to receive(:list_files).and_return([])
    hardship_reason_page.submit_reason
  end
end

Given("I create a direct tax application where HMRC claim I owe money") do
  navigate_to_dispute_type_page(:income_tax_case)
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_owe_option
end

Given("I create a direct tax application about a penalty") do
  navigate_to_dispute_type_page(:income_tax_case)
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
end

Given("I create an indirect tax application where HMRC claim I owe money") do
  navigate_to_dispute_type_page(:vat_case)
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_owe_option
end

Given("I create an indirect tax application about a penalty") do
  navigate_to_dispute_type_page(:vat_case)
  expect(dispute_type_page.content).to have_header
  dispute_type_page.submit_penalty_or_surcharge
end