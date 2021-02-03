Then("I am taken to the representative type page") do
  expect(representative_professional_page.content).to have_header
end