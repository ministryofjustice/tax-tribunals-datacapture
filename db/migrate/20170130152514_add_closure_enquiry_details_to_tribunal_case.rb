class AddClosureEnquiryDetailsToTribunalCase < ActiveRecord::Migration[5.0]
  def change
    add_column :tribunal_cases, :closure_hmrc_reference, :string
    add_column :tribunal_cases, :closure_hmrc_officer, :string
    add_column :tribunal_cases, :closure_years_under_enquiry, :string
  end
end
