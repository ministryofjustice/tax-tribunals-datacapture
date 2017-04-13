class AddUserCaseReferenceToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :user_case_reference, :string
  end
end
