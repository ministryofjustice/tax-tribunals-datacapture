Then("I am able to click on the external Help link") do
  expect(base_page.footer.help_link["href"]).to eq "https://www.gov.uk/help"
end

Then("I am able to click on the Smart Survey link") do
  expect(home_page).to have_link(I18n.t('layouts.phase_banner.feedback_link'), href: 'https://www.smartsurvey.co.uk/s/TTFeed20/')
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
  expect(page).to have_selector('h1', text: I18n.t('layouts.footer_links.contact'))
end

Then("I am on the Cookies page") do
  expect(page).to have_selector('h1', text: I18n.t('layouts.footer_links.cookies'))
end

Then("I am on the Privacy policy page") do
  expect(page).to have_selector('h1', text: I18n.t('privacy.header'))
end

Then("I am on the Accessibility statement page") do
  expect(page).to have_selector('h1', text: I18n.t('home.accessibility.heading_html'))
end

Then("Verify language selector links") do
  expect(page).to have_selector('a', text: I18n.t('selector.language'))
end

Then("I am on the Terms and conditions page") do
  expect(page).to have_selector('h1', text: I18n.t('layouts.footer_links.terms_and_conditions'))
end
