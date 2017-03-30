class TweakColumnTypes < ActiveRecord::Migration[5.0]
  def change
    change_column :tribunal_cases, :hardship_reason, :text
    change_column :tribunal_cases, :outcome, :text
    change_column :tribunal_cases, :taxpayer_contact_postcode, :string
    change_column :tribunal_cases, :representative_contact_postcode, :string
  end
end
