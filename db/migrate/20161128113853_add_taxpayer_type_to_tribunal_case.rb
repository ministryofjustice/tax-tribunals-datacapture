class AddTaxpayerTypeToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :taxpayer_type, :string
  end
end
