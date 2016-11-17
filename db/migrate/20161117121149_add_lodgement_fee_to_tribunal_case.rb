class AddLodgementFeeToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :lodgement_fee, :string
  end
end
