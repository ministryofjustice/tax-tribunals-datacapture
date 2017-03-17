class RenameRepresentativeIsLegalProfessional < ActiveRecord::Migration[5.0]
  def change
    rename_column :tribunal_cases, :representative_is_legal_professional, :representative_professional_status
  end
end
