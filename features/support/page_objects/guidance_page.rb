class GuidancePage < BasePage
  set_url '/en/guidance'

  section :content, '#main-content' do
    element :header, 'h1', text: 'Guide to appealing a tax decision'
    element :visible_first_question, '#accordion-1-heading-0', visible: true
    element :visible_second_question, '#accordion-1-heading-1', visible: true
    element :visible_first_answer, '#accordion-1-content-0', visible: true
    element :visible_second_answer, '#accordion-1-content-1', visible: true
    element :open_all, '#accordion-1 .govuk-accordion__open-all'
  end

  def click_a_question
    content.visible_first_question.click
  end

  def click_open_all
    content.open_all.click
  end
end
