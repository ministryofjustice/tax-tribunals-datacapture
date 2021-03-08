class AddLanguageFieldToTribunalCase < ActiveRecord::Migration[6.0]
  def change
    add_column :tribunal_cases, :language, :string
  end
end
