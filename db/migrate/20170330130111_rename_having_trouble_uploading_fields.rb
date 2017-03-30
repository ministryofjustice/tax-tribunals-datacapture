class RenameHavingTroubleUploadingFields < ActiveRecord::Migration[5.0]
  def change
    rename_column :tribunal_cases, :having_problems_uploading_documents, :having_problems_uploading
    rename_column :tribunal_cases, :having_problems_uploading_details, :having_problems_uploading_explanation
  end
end
