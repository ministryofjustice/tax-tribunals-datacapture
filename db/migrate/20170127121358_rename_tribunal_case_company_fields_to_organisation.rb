class RenameTribunalCaseCompanyFieldsToOrganisation < ActiveRecord::Migration[5.0]
  def change
    rename_column :tribunal_cases, :taxpayer_company_name, :taxpayer_organisation_name
    rename_column :tribunal_cases, :taxpayer_company_fao, :taxpayer_organisation_fao
    rename_column :tribunal_cases, :taxpayer_company_registration_number, :taxpayer_organisation_registration_number
  end
end
