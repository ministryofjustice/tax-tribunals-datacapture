Given("I visit the guidance page") do
  guidance_page.load_page
  expect(guidance_page.content).to have_header
end

Then("I am on the home page") do
  expect(home_page.content).to have_header
end

Then("I can only see a question and not the answer") do
  expect(guidance_page.content).to have_visible_first_question
  expect(guidance_page.content).not_to have_visible_first_answer
end

When("I click a question") do
  guidance_page.click_a_question
end

Then("I can see a question and the answer") do
  expect(guidance_page.content).to have_visible_first_question
  expect(guidance_page.content).to have_visible_first_answer
end

When("I click open all") do
  guidance_page.click_open_all
end

Then("I can see all questions and answers") do
  expect(guidance_page.content).to have_visible_first_question
  expect(guidance_page.content).to have_visible_second_question
  expect(guidance_page.content).to have_visible_first_answer
  expect(guidance_page.content).to have_visible_second_answer
end
