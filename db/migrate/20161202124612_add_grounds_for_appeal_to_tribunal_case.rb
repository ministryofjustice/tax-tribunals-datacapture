class AddGroundsForAppealToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :grounds_for_appeal, :text
    add_column :tribunal_cases, :grounds_for_appeal_file_name, :string
  end
end
