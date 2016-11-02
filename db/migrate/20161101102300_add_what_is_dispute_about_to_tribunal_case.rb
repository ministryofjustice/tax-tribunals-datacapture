class AddWhatIsDisputeAboutToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :what_is_dispute_about, :string
  end
end
