Then("I am able to click on the external Help link") do
  expect(base_page.footer.help_link["href"]).to eq "https://www.gov.uk/help"
end

When("I click on the Contact link") do
  base_page.footer.contact_link.click
end

When("I click on the Cookies link") do
  base_page.footer.cookies_link.click
end

When("I click on the Privacy policy link") do
  base_page.footer.privacy_link.click
end

When("I click on the Accessibility statement link") do
  base_page.footer.accessibility_link.click
end

When("I click on the Terms and conditions link") do
  base_page.footer.terms_link.click
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
