class AddTaxpayerFeedbackConsentToTribunalCases < ActiveRecord::Migration[6.0]
  def change
    add_column :tribunal_cases, :taxpayer_feedback_consent, :boolean, default: false
  end
end
