class RenameWhatIsDisputeAboutToDisputeType < ActiveRecord::Migration[5.0]
  def change
    rename_column :tribunal_cases, :what_is_dispute_about, :dispute_type
  end
end
