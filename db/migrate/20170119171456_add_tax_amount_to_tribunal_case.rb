class AddTaxAmountToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :tax_amount, :string
  end
end
