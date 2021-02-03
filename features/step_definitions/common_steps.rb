Given("I submit that I am an individual") do
  taxpayer_type_page.submit_individual
end

Given("I submit that I am a company") do
  taxpayer_type_page.submit_company
end

Given("I submit that I am an other") do
  taxpayer_type_page.submit_other
end

Given("I click the back button") do
  back
end

When("I click on save and come back later") do
  save_and_come_back
end