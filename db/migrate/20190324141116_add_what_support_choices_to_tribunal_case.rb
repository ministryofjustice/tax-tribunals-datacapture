class AddWhatSupportChoicesToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :language_interpreter, :boolean
    add_column :tribunal_cases, :sign_language_interpreter, :boolean
    add_column :tribunal_cases, :hearing_loop, :boolean
    add_column :tribunal_cases, :disabled_access, :boolean
    add_column :tribunal_cases, :other_support, :boolean
    add_column :tribunal_cases, :other_support_details, :string
  end
end
