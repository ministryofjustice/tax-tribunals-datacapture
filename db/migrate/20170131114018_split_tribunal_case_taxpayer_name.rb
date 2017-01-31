class SplitTribunalCaseTaxpayerName < ActiveRecord::Migration[5.0]
  def change
    remove_column :tribunal_cases, :taxpayer_individual_name
    add_column :tribunal_cases, :taxpayer_individual_first_name, :string
    add_column :tribunal_cases, :taxpayer_individual_last_name, :string
  end
end
