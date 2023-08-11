class ClosureCaseTypePage < BasePage
  set_url '/' + ENV['TEST_LOCALE'] + '/steps/closure/case_type'

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('check_answers.closure_case_type.question')
    element :one_on_list, '.govuk-hint'
    element :personal_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.personal_return')
    element :company_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.company_return')
    element :partnership_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.partnership_return')
    element :trustee_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.trustee_return')
    element :enterprise_mgmt_incentives, 'label', text: I18n.t('check_answers.closure_case_type.answers.enterprise_mgmt_incentives')
    element :non_resident_capital_gains_tax, 'label', text: I18n.t('check_answers.closure_case_type.answers.non_resident_capital_gains_tax')
    element :stamp_duty_land_tax_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.stamp_duty_land_tax_return')
    element :transactions_in_securities, 'label', text: I18n.t('check_answers.closure_case_type.answers.transactions_in_securities')
    element :claim_or_amendment, 'label', text: I18n.t('check_answers.closure_case_type.answers.claim_or_amendment')
  end

  def submit_personal_return
    content.personal_return.click
    continue_or_save_continue
  end

  def submit_company_return
    content.company_return.click
    continue_or_save_continue
  end

  def submit_partnership_return
    content.partnership_return.click
    continue_or_save_continue
  end

  def submit_trustee_return
    content.trustee_return.click
    continue_or_save_continue
  end

  def submit_enterprise_mgmt_incentives
    content.enterprise_mgmt_incentives.click
    continue_or_save_continue
  end

  def submit_non_resident_capital_gains_tax
    content.non_resident_capital_gains_tax.click
    continue_or_save_continue
  end

  def submit_stamp_duty_land_tax_return
    content.stamp_duty_land_tax_return.click
    continue_or_save_continue
  end

  def submit_transactions_in_securities
    content.transactions_in_securities.click
    continue_or_save_continue
  end

  def submit_claim_or_amendment
    content.claim_or_amendment.click
    continue_or_save_continue
  end
end
