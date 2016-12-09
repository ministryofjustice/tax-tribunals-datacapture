class AddDocumentsChecklistToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :original_notice_provided, :boolean, default: false
    add_column :tribunal_cases, :review_conclusion_provided, :boolean, default: false
    add_column :tribunal_cases, :additional_documents_provided, :boolean, default: false
    add_column :tribunal_cases, :additional_documents_info, :text
    add_column :tribunal_cases, :having_problems_uploading_documents, :boolean, default: false
  end
end
