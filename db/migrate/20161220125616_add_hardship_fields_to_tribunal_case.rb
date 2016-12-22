class AddHardshipFieldsToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :disputed_tax_paid, :string
    add_column :tribunal_cases, :hardship_review_requested, :string
    add_column :tribunal_cases, :hardship_review_status, :string
  end
end
