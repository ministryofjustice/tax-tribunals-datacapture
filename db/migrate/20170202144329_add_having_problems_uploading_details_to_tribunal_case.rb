class AddHavingProblemsUploadingDetailsToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :having_problems_uploading_explanation, :text
  end
end
