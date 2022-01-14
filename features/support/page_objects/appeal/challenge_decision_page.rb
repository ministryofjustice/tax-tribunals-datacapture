class ChallengeDecisionPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/challenge/decision'

  section :content, '#main-content' do
    element :appeal_header, 'h1', text: I18n.t('steps.challenge.decision.edit.heading_direct')
    element :review_header, 'h1', text: I18n.t('steps.challenge.decision.edit.heading_indirect')
    element :help_with_challenging_a_decision, 'span', text: I18n.t('steps.challenge.decision.edit.help_panel.heading')
    element :sign_out,'label', text: 'layouts.current_user_menu.logout'
    element :dropdown_content, 'p', text: "The original notice letter will say what you can do when you disagree with a tax decision."
    element :challenge_dropdown, 'li', text: 'challenging a tax decision with HM Revenue & Customs (HMRC)'
    element :border_force, 'li', text: 'options when UK Border Force (UKBF) seizes your things'
    element :challenge_NCA, 'li', text: 'how to challenge a National Crime Agency (NCA) decision'
    section :error,'.govuk-error-summary' do
      element :error_heading, '#error-summary-title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def help_with_challenging_dropdown
    content.help_with_challenging_a_decision.click
  end

  def challenging_decision_HMRC
    content.challenge_dropdown.click
  end

  def nca
    content.challenge_NCA.click
  end

  def border_force
    content.border_force.click
  end

  def logout
    content.sign_out.click
  end

end
