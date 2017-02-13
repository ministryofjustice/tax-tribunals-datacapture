# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170213145741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "tribunal_cases", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",                                                                            null: false
    t.datetime "updated_at",                                                                            null: false
    t.string   "case_type"
    t.string   "dispute_type"
    t.string   "penalty_level"
    t.string   "in_time"
    t.text     "lateness_reason"
    t.string   "taxpayer_type"
    t.text     "taxpayer_contact_address"
    t.text     "taxpayer_contact_postcode"
    t.string   "taxpayer_contact_email"
    t.string   "taxpayer_contact_phone"
    t.string   "taxpayer_organisation_name"
    t.string   "taxpayer_organisation_fao"
    t.string   "taxpayer_organisation_registration_number"
    t.text     "grounds_for_appeal"
    t.string   "grounds_for_appeal_file_name"
    t.uuid     "files_collection_ref",                            default: -> { "uuid_generate_v4()" }
    t.boolean  "original_notice_provided",                        default: false
    t.boolean  "review_conclusion_provided",                      default: false
    t.boolean  "having_problems_uploading_documents",             default: false
    t.string   "challenged_decision"
    t.string   "disputed_tax_paid"
    t.string   "hardship_review_requested"
    t.string   "hardship_review_status"
    t.string   "case_reference"
    t.string   "penalty_amount"
    t.string   "tax_amount"
    t.string   "challenged_decision_status"
    t.string   "outcome"
    t.string   "case_type_other_value"
    t.string   "intent"
    t.string   "closure_case_type"
    t.string   "closure_hmrc_reference"
    t.string   "closure_hmrc_officer"
    t.string   "closure_years_under_enquiry"
    t.text     "closure_additional_info"
    t.boolean  "closure_problems_uploading_documents",            default: false
    t.text     "closure_problems_uploading_details"
    t.string   "taxpayer_individual_first_name"
    t.string   "taxpayer_individual_last_name"
    t.string   "has_representative"
    t.string   "representative_type"
    t.string   "representative_individual_first_name"
    t.string   "representative_individual_last_name"
    t.text     "representative_contact_address"
    t.text     "representative_contact_postcode"
    t.string   "representative_contact_email"
    t.string   "representative_contact_phone"
    t.string   "representative_organisation_name"
    t.string   "representative_organisation_fao"
    t.string   "representative_organisation_registration_number"
    t.text     "having_problems_uploading_details"
    t.string   "user_type"
    t.string   "navigation_stack",                                default: [],                                       array: true
    t.string   "representative_is_legal_professional"
    t.index ["case_reference"], name: "index_tribunal_cases_on_case_reference", unique: true, using: :btree
  end

end
