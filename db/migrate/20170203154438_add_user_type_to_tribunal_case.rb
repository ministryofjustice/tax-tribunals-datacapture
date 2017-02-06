class AddUserTypeToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :user_type, :string
  end
end
