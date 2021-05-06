class PenaltyAmountPage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/appeal/penalty_amount'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.appeal.penalty_amount.edit.heading')
    element :one_hundred_or_less_option, 'label', text: I18n.t('dictionary.PENALTY_LEVELS.penalty_level_1')
    element :one_hundred_to_twenty_thousand_option, 'label', text: I18n.t('dictionary.PENALTY_LEVELS.penalty_level_2')
    element :penalty_amount_input, "input[name='steps_appeal_penalty_amount_form[penalty_amount]']"
    section :error_summary, '.govuk-error-summary__body' do
      element :enter_penalty_error, 'a', text: I18n.t('dictionary.blank_penalty_amount')
      element :select_option_error, 'a', text: I18n.t('activemodel.errors.models.steps/appeal/penalty_amount_form.attributes.penalty_level.inclusion')
    end
  end

  def submit_100_or_less
    content.one_hundred_or_less_option.click
    continue_or_save_continue
  end

  def submit_invalid_100_to_20000
    content.one_hundred_to_twenty_thousand_option.click
    continue_or_save_continue
  end

  def submit_valid_100_to_20000
    content.one_hundred_to_twenty_thousand_option.click
    content.penalty_amount_input.set '200'
    continue_or_save_continue
  end
end
