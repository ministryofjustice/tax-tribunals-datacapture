class AddHardshipUploadFieldsToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :hardship_reason_file_name, :string
  end
end
