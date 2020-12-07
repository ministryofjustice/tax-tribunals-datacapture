Then("I am able to click on the external Help link") do
  expect(base_page.footer.help_link["href"]).to eq "https://www.gov.uk/help"
end

When("I click on the Contact link") do
  go_to_contact_page
end

When("I click on the Cookies link") do
  go_to_cookies_page
end

When("I click on the Privacy policy link") do
  go_to_privacy_page
end

When("I click on the Accessibility statement link") do
  go_to_accessibility_page
end

When("I click on the Terms and conditions link") do
  go_to_terms_page
end

Then("I am on the Contact page") do
  expect(page).to have_selector('h1', text: "Contact")
end

Then("I am on the Cookies page") do
  expect(page).to have_selector('h1', text: "Cookies")
end

Then("I am on the Privacy policy page") do
  expect(page).to have_selector('h1', text: "HMCTS Privacy Policy")
end

Then("I am on the Accessibility statement page") do
  expect(page).to have_selector('h1', text: "Accessibility statement for appealing to the Tax Tribunal")
end

Then("I am on the Terms and conditions page") do
  expect(page).to have_selector('h1', text: "Terms and Conditions")
end
