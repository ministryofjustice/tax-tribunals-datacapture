class RenameWhatIsPenaltyOrSurchargeAmountToPenaltyAmount < ActiveRecord::Migration[5.0]
  def change
    rename_column :tribunal_cases, :what_is_penalty_or_surcharge_amount, :penalty_amount
  end
end
