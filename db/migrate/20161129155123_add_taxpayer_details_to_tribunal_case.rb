class AddTaxpayerDetailsToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :taxpayer_individual_name, :string
    add_column :tribunal_cases, :taxpayer_contact_address, :text
    add_column :tribunal_cases, :taxpayer_contact_postcode, :text
    add_column :tribunal_cases, :taxpayer_contact_email, :string
    add_column :tribunal_cases, :taxpayer_contact_phone, :string
    add_column :tribunal_cases, :taxpayer_company_name, :string
    add_column :tribunal_cases, :taxpayer_company_fao, :string
    add_column :tribunal_cases, :taxpayer_company_registration_number, :string
  end
end
