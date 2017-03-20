class RemoveFilenamesFromTribunalCase < ActiveRecord::Migration[5.0]
  def change
    remove_column :tribunal_cases, :grounds_for_appeal_file_name
    remove_column :tribunal_cases, :hardship_reason_file_name
    remove_column :tribunal_cases, :representative_approval_file_name
  end
end
