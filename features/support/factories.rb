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

    trait :penalty do
      dispute_type { DisputeType::PENALTY }
    end

    trait :amount_and_penalty do
      dispute_type { DisputeType::AMOUNT_AND_PENALTY }
    end

    trait :penalty_100_or_less do
      penalty_level { PenaltyLevel::PENALTY_LEVEL_1 }
      # penalty_amount { '' }
    end

    trait :yes_in_time do
      in_time { InTime::YES }
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
      taxpayer_contact_email { 'matching@email.com' }
      taxpayer_contact_phone { '2' }
    end

    trait :no_email do
      send_taxpayer_copy { SendApplicationDetails::NONE }
    end

    trait :has_representative_no do
      has_representative { HasRepresentative::NONE }
    end

    trait :valid_gfa do
      grounds_for_appeal { 'gfa' }
    end

    trait :valid_outcome do
      outcome { 'outcome' }
    end

    trait :yes_need_support do
      need_support { NeedSupport::YES }
    end

    trait :no_support do
      need_support { NeedSupport::NO }
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

    trait :representative_user_type do
      user_type { UserType::REPRESENTATIVE }
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
      taxpayer_contact_email { 'matching@email.com' }
      taxpayer_contact_phone { '2' }
    end

    trait :no_email do
      send_taxpayer_copy { SendApplicationDetails::NONE }
    end

    trait :has_representative_no do
      has_representative { HasRepresentative::NO }
    end

    trait :valid_enquiry_details do
      closure_hmrc_reference { 'de' }
      closure_years_under_enquiry { 'de' }
      closure_hmrc_officer { 'de' }
    end

    trait :valid_enquiry_details do
      closure_hmrc_reference { 'de' }
      closure_years_under_enquiry { 'de' }
      closure_hmrc_officer { 'de' }
    end
  end
end
