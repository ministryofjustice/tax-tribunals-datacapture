Given(/^I navigate to the letter upload type page$/) do
  navigate_to_the_letter_upload_type_page
end

When(/^I press one document option$/) do
  letter_upload_type_page.submit_one_document_option
end

Then(/^I am on the letter upload page$/) do
  expect(letter_upload_page.content).to have_header
end

When(/^I press upload as multiple pages option$/) do
  letter_upload_type_page.submit_multiple_option
end

Then(/^I am on the documents upload page$/) do
  expect(page).to have_text("Upload the review conclusion letter")
end

When(/^I press I do not have a letter$/) do
  letter_upload_type_page.no_letter
end

Then(/^I am on the letter upload page and I see you the validity message$/) do
  expect(letter_upload_type_page.content).to have_text("You must upload a copy of the letter for your appeal to be valid.")
end

When(/^I successfully upload a document$/) do
  expect(letter_upload_page.content).to have_lead_text
  identifier  = 'steps-details-letter-upload-form-supporting-letter-document-field'
  filename    = 'features/support/sample_file/to_upload.jpg'
  letter_upload_page.attach_file(identifier, filename)
  continue_or_save_continue
end

Then(/^I am on the check answers page$/) do
  expect(check_answers_page.content).to have_header
end

When(/^I press continue with no file uploaded$/) do
  continue_or_save_continue
end

Then(/^I see the no upload error$/) do
  expect(letter_upload_page.content.error).to have_error_heading
end

When(/^I select I am having trouble uploading my document$/) do
  letter_upload_page.select_trouble_uploading
  expect(page).to have_text("What to do next")
  letter_upload_page.valid_text_reason
end

Then(/^I am on the complete appeal by post page$/) do
  expect(page).to have_text("Complete your appeal by post")
end

Then(/^I am on the letter upload type page and I see the validity message$/) do
  expect(page).to have_text("You must upload a copy of the letter for your appeal to be valid.")
end

Then(/^I am taken to the home or save appeal page$/) do
  expect(home_page.content).to have_header
  #as test runs on logged in case
end