class AddRepApprovalDocumentToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :representative_approval_file_name, :string
  end
end
