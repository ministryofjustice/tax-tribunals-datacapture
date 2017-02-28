class RemoveClosureProblemsUploadingFromTribunalCase < ActiveRecord::Migration[5.0]
  def change
    remove_column :tribunal_cases, :closure_problems_uploading_documents
    remove_column :tribunal_cases, :closure_problems_uploading_details
  end
end
