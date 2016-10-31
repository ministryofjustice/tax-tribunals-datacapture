class AddPenaltyOrSurchargeAmountToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :what_is_penalty_or_surcharge_amount, :string
  end
end
