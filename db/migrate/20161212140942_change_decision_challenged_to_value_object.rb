class ChangeDecisionChallengedToValueObject < ActiveRecord::Migration[5.0]
  def change
    remove_column :tribunal_cases, :challenged_decision
    add_column :tribunal_cases, :challenged_decision, :string
  end
end
