class RenamePenaltyAmountToPenaltyLevel < ActiveRecord::Migration[5.0]
  def change
    rename_column :tribunal_cases, :penalty_amount, :penalty_level
  end
end
