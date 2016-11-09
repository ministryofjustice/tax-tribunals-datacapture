class RenameWhatIsAppealAboutToCaseType < ActiveRecord::Migration[5.0]
  def change
    rename_column :tribunal_cases, :what_is_appeal_about, :case_type
  end
end
