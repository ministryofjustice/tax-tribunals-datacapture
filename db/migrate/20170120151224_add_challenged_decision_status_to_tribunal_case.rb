class AddChallengedDecisionStatusToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :challenged_decision_status, :string
  end
end
