class AddPdfGenerationStatusToTribunalCase < ActiveRecord::Migration[6.0]
  def change
    add_column :tribunal_cases, :pdf_generation_status, :string
  end
end
