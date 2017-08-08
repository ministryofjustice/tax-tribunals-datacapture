class AddLetterUploadTypeToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :letter_upload_type, :string
  end
end
