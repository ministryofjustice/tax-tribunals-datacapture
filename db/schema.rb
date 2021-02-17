# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_05_141827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "tribunal_cases", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "case_type"
    t.string "dispute_type"
    t.string "penalty_level"
    t.string "in_time"
    t.text "lateness_reason"
    t.string "taxpayer_type"
    t.text "taxpayer_contact_address"
    t.string "taxpayer_contact_postcode"
    t.string "taxpayer_contact_email"
    t.string "taxpayer_contact_phone"
    t.string "taxpayer_organisation_name"
    t.string "taxpayer_organisation_fao"
    t.string "taxpayer_organisation_registration_number"
    t.text "grounds_for_appeal"
    t.uuid "files_collection_ref", default: -> { "uuid_generate_v4()" }
    t.boolean "having_problems_uploading", default: false
    t.string "challenged_decision"
    t.string "disputed_tax_paid"
    t.string "hardship_review_requested"
    t.string "hardship_review_status"
    t.string "case_reference"
    t.string "penalty_amount"
    t.string "tax_amount"
    t.string "challenged_decision_status"
    t.text "outcome"
    t.string "case_type_other_value"
    t.string "intent"
    t.string "closure_case_type"
    t.string "closure_hmrc_reference"
    t.string "closure_hmrc_officer"
    t.string "closure_years_under_enquiry"
    t.text "closure_additional_info"
    t.string "taxpayer_individual_first_name"
    t.string "taxpayer_individual_last_name"
    t.string "has_representative"
    t.string "representative_type"
    t.string "representative_individual_first_name"
    t.string "representative_individual_last_name"
    t.text "representative_contact_address"
    t.string "representative_contact_postcode"
    t.string "representative_contact_email"
    t.string "representative_contact_phone"
    t.string "representative_organisation_name"
    t.string "representative_organisation_fao"
    t.string "representative_organisation_registration_number"
    t.text "having_problems_uploading_explanation"
    t.string "user_type"
    t.string "navigation_stack", default: [], array: true
    t.string "representative_professional_status"
    t.string "dispute_type_other_value"
    t.string "case_status"
    t.text "hardship_reason"
    t.uuid "user_id"
    t.string "user_case_reference"
    t.string "letter_upload_type"
    t.string "taxpayer_contact_city"
    t.string "taxpayer_contact_country"
    t.string "representative_contact_city"
    t.string "representative_contact_country"
    t.string "need_support"
    t.boolean "language_interpreter"
    t.boolean "sign_language_interpreter"
    t.boolean "hearing_loop"
    t.boolean "disabled_access"
    t.boolean "other_support"
    t.string "other_support_details"
    t.string "language_interpreter_details"
    t.string "sign_language_interpreter_details"
    t.boolean "eu_exit"
    t.string "send_taxpayer_copy"
    t.string "send_representative_copy"
    t.index ["case_reference"], name: "index_tribunal_cases_on_case_reference", unique: true
    t.index ["user_id"], name: "index_tribunal_cases_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.string "session_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "tribunal_cases", "users"
end
