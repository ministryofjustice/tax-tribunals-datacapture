class AddSupportAtHearingFieldsToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :language_interpreter_details, :string
    add_column :tribunal_cases, :sign_language_interpreter_details, :string
  end
end
