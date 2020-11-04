class SessionsController < ApplicationController
  def ping
    head(:no_content)
  end

  def destroy
    # When redirecting to the survey, we want to logout the user. But when only taking the users to the home,
    # we don't want to log them out but instead only reset the current case in session.
    show_survey = params[:survey] == 'true'
    show_survey ? reset_session : reset_tribunal_case_session

    respond_to do |format|
      format.html { redirect_to show_survey ? Rails.configuration.survey_link : root_path }
      format.json { render json: {} }
    end
  end

  def create_and_fill_appeal
    raise 'For development use only' unless Rails.env.development?
    # :nocov:
    tribunal_case.update(fake_appeal_data)
    redirect_to edit_steps_lateness_in_time_path
    # :nocov:
  end

  def create_and_fill_appeal_and_lateness
    raise 'For development use only' unless Rails.env.development?
    # :nocov:
    tribunal_case.update(fake_appeal_data.merge(fake_lateness_data))
    redirect_to edit_steps_details_user_type_path
    # :nocov:
  end

  # although this is linked from the 'setup everything' developer tools button,
  # it does not upload any documents. So, if you need real documents for the
  # case, you need to use the 'Change' link on the 'Check your answers' page
  # and add some.
  def create_and_fill_appeal_and_lateness_and_appellant
    raise 'For development use only' unless Rails.env.development?
    # :nocov:
    tribunal_case.update(fake_appeal_data.merge(fake_lateness_data.merge(fake_details_data)))

    redirect_to steps_details_check_answers_path
    # :nocov:
  end

  private

  # :nocov:
  def fake_appeal_data
    {
      intent: Intent::TAX_APPEAL,
      case_type: CaseType::VAT,
      challenged_decision: ChallengedDecision::YES,
      challenged_decision_status: ChallengedDecisionStatus::OVERDUE,
      dispute_type: DisputeType::AMOUNT_OF_TAX_OWED_BY_TAXPAYER,
      tax_amount: '£123,456.78',
      disputed_tax_paid: DisputedTaxPaid::NO,
      hardship_review_requested: HardshipReviewRequested::YES,
      hardship_review_status: HardshipReviewStatus::REFUSED,
      hardship_reason: Faker::ChuckNorris.fact
    }
  end

  def fake_lateness_data
    {
      in_time: InTime::UNSURE,
      lateness_reason: Faker::ChuckNorris.fact
    }
  end

  def fake_details_data
    {
      taxpayer_type: ContactableEntityType::INDIVIDUAL,
      taxpayer_contact_phone: Faker::PhoneNumber.phone_number,
      taxpayer_contact_email: Faker::Internet.email,
      taxpayer_contact_postcode: Faker::Address.postcode,
      taxpayer_individual_first_name: Faker::Name.first_name,
      taxpayer_individual_last_name: Faker::Name.last_name,
      taxpayer_contact_address: [Faker::Address.street_address, Faker::Address.city, Faker::Address.county].join("\n"),
      has_representative: HasRepresentative::YES,
      representative_professional_status: RepresentativeProfessionalStatus::ENGLAND_OR_WALES_OR_NI_LEGAL_REP,
      representative_type: ContactableEntityType::COMPANY,
      representative_organisation_name: Faker::Company.name,
      representative_organisation_registration_number: Faker::Company.duns_number,
      representative_organisation_fao: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
      representative_contact_phone: Faker::PhoneNumber.phone_number,
      representative_contact_email: Faker::Internet.email,
      representative_contact_postcode: Faker::Address.postcode,
      representative_contact_address: [Faker::Address.street_address, Faker::Address.city, Faker::Address.county].join("\n"),
      grounds_for_appeal: Faker::Lorem.paragraph(2),
      outcome: Faker::ChuckNorris.fact,
      need_support: NeedSupport::YES,
      language_interpreter: true,
      language_interpreter_details: Faker::Lorem.word,
      hearing_loop: true,
      other_support: true,
      other_support_details: Faker::Lorem.paragraph(1),
    }
  end

  def tribunal_case
    @tribunal_case ||= TribunalCase.find_by_id(session[:tribunal_case_id]) || TribunalCase.create.tap do |tribunal_case|
      session[:tribunal_case_id] = tribunal_case.id
    end
  end
  # :nocov:
end
