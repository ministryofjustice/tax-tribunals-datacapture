class AddClosureProblemsUploadingDocumentsToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :closure_problems_uploading_documents, :boolean, default: false
    add_column :tribunal_cases, :closure_problems_uploading_details, :text
  end
end
