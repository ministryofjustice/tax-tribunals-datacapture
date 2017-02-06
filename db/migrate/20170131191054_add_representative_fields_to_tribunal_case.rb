class AddRepresentativeFieldsToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :representative_type, :string
    add_column :tribunal_cases, :representative_individual_first_name, :string
    add_column :tribunal_cases, :representative_individual_last_name, :string
    add_column :tribunal_cases, :representative_contact_address, :text
    add_column :tribunal_cases, :representative_contact_postcode, :text
    add_column :tribunal_cases, :representative_contact_email, :string
    add_column :tribunal_cases, :representative_contact_phone, :string
    add_column :tribunal_cases, :representative_organisation_name, :string
    add_column :tribunal_cases, :representative_organisation_fao, :string
    add_column :tribunal_cases, :representative_organisation_registration_number, :string
  end
end
