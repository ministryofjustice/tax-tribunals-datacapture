class AddHasRepresentativeToTribunalCases < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :has_representative, :string
  end
end
