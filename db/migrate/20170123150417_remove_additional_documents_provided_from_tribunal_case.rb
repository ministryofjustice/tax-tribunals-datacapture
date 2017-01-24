class RemoveAdditionalDocumentsProvidedFromTribunalCase < ActiveRecord::Migration[5.0]
  def up
    remove_column :tribunal_cases, :additional_documents_provided
    remove_column :tribunal_cases, :additional_documents_info
  end

  def down
    add_column :tribunal_cases, :additional_documents_provided, :boolean, default: false
    add_column :tribunal_cases, :additional_documents_info, :text
  end
end
