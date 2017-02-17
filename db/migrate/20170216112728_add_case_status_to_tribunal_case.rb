class AddCaseStatusToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :case_status, :string
  end
end
