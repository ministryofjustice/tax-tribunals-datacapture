Given("I navigate to the send taxpayer copy page as the taxpayer") do
  navigate_to_send_taxpayer_copy_page
  expect(send_taxpayer_copy_page.content).to have_header
end

When("I submit yes and submit blank email field") do
  expect(send_representative_copy_page.content).to have_header
  submit_yes
end

When("I submit an email that doesn't match on the send representative copy page") do
  send_representative_copy_page.submit_invalid_email
end

When("I submit an email that does match on the send representative copy page") do
  send_representative_copy_page.submit_valid_email
end

Then("I should see not matching email error") do
  expect(send_representative_copy_page.content).to have_not_matching_error_message
end

When("I select 'email' and submit a valid email on the send taxpayer copy page") do
  send_taxpayer_copy_page.submit_email_and_a_valid_email
end

Given("I go back to representative details page and add an email address and submit") do
  back
  expect(representative_details_page.content).to have_header
  representative_details_page.add_email_and_submit
end

Then("I should be on the enquiry details page") do
  expect(enquiry_details_page.content).to have_header
end

Then("I see the error") do
  expect(send_taxpayer_copy_page.content.error).to have_error_heading
end

When("I submit no") do
  submit_no
end

Then("I am on the has representative page") do
  expect(has_representative_page.content).to have_header
end

Given(/^Given I navigate to the send taxpayer copy page as the taxpayer$/) do
    navigate_to_send_taxpayer_copy_page
    expect(send_taxpayer_copy_page.content).to have_header
  end

And(/^I submit a valid email on the send taxpayer copy page$/) do
  expect(send_taxpayer_copy_page.content).to have_header
  send_taxpayer_copy_page.submit_email_and_valid_email
end

When(/^I submit an invalid email on the send taxpayer copy page$/) do
  expect(send_taxpayer_copy_page.content).to have_header
  send_taxpayer_copy_page.submit_email_and_invalid_email
end

Then(/^I will see a non matching email error$/) do
  expect(send_taxpayer_copy_page.content.error).to have_error_heading
end

When(/^I select no email or text$/) do
  send_taxpayer_copy_page.submit_no_contact
end

And(/^I submit that I do not have a representative$/) do
  expect(has_representative_page.content).to have_header
  submit_no
end
