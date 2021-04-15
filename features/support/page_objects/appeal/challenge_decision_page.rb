class ChallengeDecisionPage < BasePage
  set_url '/en/steps/challenge/decision'

  section :content, '#main-content' do
    element :appeal_header, 'h1', text: I18n.t('steps.challenge.decision.edit.heading_direct')
    element :review_header, 'h1', text: I18n.t('steps.challenge.decision.edit.heading_indirect')
    element :help_with_challenging_a_decision, 'span', text: I18n.t('steps.challenge.decision.edit.help_panel.heading')
  end
end
