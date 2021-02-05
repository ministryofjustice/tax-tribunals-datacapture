class AddSendApplicationDetailsFieldsToTribunaCase < ActiveRecord::Migration[6.0]
  def change
    add_column :tribunal_cases, :send_taxpayer_copy, :string
    add_column :tribunal_cases, :send_representative_copy, :string
  end
end
