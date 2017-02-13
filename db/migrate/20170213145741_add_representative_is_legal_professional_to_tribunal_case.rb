class AddRepresentativeIsLegalProfessionalToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :representative_is_legal_professional, :string
  end
end
