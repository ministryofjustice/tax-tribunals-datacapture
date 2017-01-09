class RemoveLodgementFeeFromTribunalCases < ActiveRecord::Migration[5.0]
  def change
    remove_column :tribunal_cases, :lodgement_fee
  end
end
