Given("I am on the contact HMRC page") do
  go_to_contact_hmrc_page
  expect(contact_hmrc_page.content).to have_header
end

Given("I select the button to contact HMRC") do
  contact_hmrc_page.redirect_to_contact_hmrc
end

Then("I am redirected to that url") do
  expect(current_url).to eq(Steps::Hardship::HardshipContactHmrcController::CONTACT_HMRC_URL)
end

Then("I have a back button") do
  expect(page).to have_link(I18n.t("generic.back_link"))
end



