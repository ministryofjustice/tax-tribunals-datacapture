class AddPenaltyAmountToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :penalty_amount, :string
  end
end
