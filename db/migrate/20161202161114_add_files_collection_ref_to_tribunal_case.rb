class AddFilesCollectionRefToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :files_collection_ref, :uuid, default: 'uuid_generate_v4()', unique: true
  end
end
