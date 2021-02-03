FactoryBot.define do
  factory :appeal_case, class: "TribunalCase" do
    user_id { '2c510a62-4ac8-4fad-acfd-d2b50b1c14f0' }
    intent { Intent::TAX_APPEAL }

    trait :income_tax_case do
      case_type { CaseType::INCOME_TAX }
    end

    trait :vat_case do
      case_type { CaseType::VAT }
    end

    trait :yes_review do
      challenged_decision { ChallengedDecision::YES }
    end

    trait :received_letter do
      challenged_decision_status { ChallengedDecisionStatus::RECEIVED }
    end

    trait :amount_and_penalty do
      dispute_type { DisputeType::AMOUNT_AND_PENALTY }
    end

    trait :valid_amount_and_penalty_amounts do
      tax_amount { '100' }
      penalty_amount { '100' }
    end

    trait :taxpayer_user_type do
      user_type { UserType::TAXPAYER }
    end

    trait :individual_taxpayer_type do
      taxpayer_type { ContactableEntityType::INDIVIDUAL }
    end

    trait :valid_taxpayer_details do
      taxpayer_individual_first_name { 'First' }
      taxpayer_individual_last_name { 'Name' }
      taxpayer_contact_address { '1 Address' }
      taxpayer_contact_city { 'Stockport' }
      taxpayer_contact_postcode { 'SK1 3DJ' }
      taxpayer_contact_country { 'UK' }
      taxpayer_contact_email { 'emali@gjksm.com' }
      taxpayer_contact_phone { '2' }
    end

    trait :has_representative do
      has_representative { HasRepresentative::NO }
    end

    trait :valid_enquiry_details do
      closure_hmrc_reference { 'de' }
      closure_years_under_enquiry { 'de' }
      closure_hmrc_officer { 'de' }
    end
  end

  factory :closure_case, class: "TribunalCase" do
    user_id { '2c510a62-4ac8-4fad-acfd-d2b50b1c14f0' }
    intent { Intent::CLOSE_ENQUIRY }

    trait :personal_return_case do
      closure_case_type { ClosureCaseType::PERSONAL_RETURN }
    end

    trait :taxpayer_user_type do
      user_type { UserType::TAXPAYER }
    end

    trait :individual_taxpayer_type do
      taxpayer_type { ContactableEntityType::INDIVIDUAL }
    end

    trait :valid_taxpayer_details do
      taxpayer_individual_first_name { 'First' }
      taxpayer_individual_last_name { 'Name' }
      taxpayer_contact_address { '1 Address' }
      taxpayer_contact_city { 'Stockport' }
      taxpayer_contact_postcode { 'SK1 3DJ' }
      taxpayer_contact_country { 'UK' }
      taxpayer_contact_email { 'emali@gjksm.com' }
      taxpayer_contact_phone { '2' }
    end

    trait :has_representative do
      has_representative { HasRepresentative::NO }
    end

    trait :valid_enquiry_details do
      closure_hmrc_reference { 'de' }
      closure_years_under_enquiry { 'de' }
      closure_hmrc_officer { 'de' }
    end
  end

  factory :user do
    id { '2c510a62-4ac8-4fad-acfd-d2b50b1c14f0' }
    email { 'user@user.com' }
    password { '!TaxTribun2897dxkjanwjk2a1' }
  end
end
