class AddCityAndCountryFields < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :taxpayer_contact_city, :string
    add_column :tribunal_cases, :taxpayer_contact_country, :string
    add_column :tribunal_cases, :representative_contact_city, :string
    add_column :tribunal_cases, :representative_contact_country, :string
  end
end
