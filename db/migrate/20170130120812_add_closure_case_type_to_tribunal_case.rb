class AddClosureCaseTypeToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :closure_case_type, :string
  end
end
