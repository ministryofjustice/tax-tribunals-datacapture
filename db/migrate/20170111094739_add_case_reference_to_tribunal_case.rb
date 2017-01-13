class AddCaseReferenceToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :case_reference, :string
    add_index :tribunal_cases, :case_reference, unique: true
  end
end
