class AddCaseTypeOtherValueToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :case_type_other_value, :string
  end
end
