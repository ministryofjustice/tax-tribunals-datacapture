class DisputeTypePage < BasePage
  set_url '/steps/appeal/dispute_type'

  section :content, '#main-content' do
    element :header, 'h1', text: 'What is your dispute about?'
    element :penalty_or_surcharge_option, 'label', text: /Penalty or surcharge/
    element :repay_option, 'label', text: 'You want HMRC to repay money'
    element :owe_option, 'label', text: 'HMRC claim you owe money'
    element :owe_and_penalty_option, 'label', text: /HMRC claim you owe money and a penalty or surcharge/
    element :paye_option, 'label', text: /Pay As You Earn/
    element :nota_option, 'label', text: 'None of the above'
    element :nota_option_textbox, "input[name='steps_appeal_dispute_type_form[dispute_type_other_value]']"
    element :enter_answer_error, 'a', text: 'Please enter an answer'
  end

  def submit_penalty_or_surcharge
    content.penalty_or_surcharge_option.click
    continue_or_save_continue
  end

  def submit_repay_option
    content.repay_option.click
    continue_or_save_continue
  end

  def submit_owe_option
    content.owe_option.click
    continue_or_save_continue
  end

  def submit_owe_and_penalty_option
    content.owe_and_penalty_option.click
    continue_or_save_continue
  end

  def submit_paye_option
    content.paye_option.click
    continue_or_save_continue
  end

  def submit_invalid_nota_option
    content.nota_option.click
    continue_or_save_continue
  end

  def submit_valid_nota_option
    content.nota_option.click
    content.nota_option_textbox.set 'Thing'
    continue_or_save_continue
  end
end
