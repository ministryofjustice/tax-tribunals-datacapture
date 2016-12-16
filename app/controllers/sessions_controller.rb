class SessionsController < ApplicationController
  def create_and_fill_cost
    raise 'For development use only' unless Rails.env.development?
    # :nocov:
    tribunal_case.update(case_type: CaseType::OTHER, challenged_decision: ChallengedDecision::YES, lodgement_fee: LodgementFee::FEE_LEVEL_3)
    redirect_to root_path
    # :nocov:
  end

  def create_and_fill_cost_and_lateness
    raise 'For development use only' unless Rails.env.development?
    # :nocov:
    tribunal_case.update(in_time: InTime::YES)
    create_and_fill_cost
    # :nocov:
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  # :nocov:
  def tribunal_case
    @tribunal_case ||= TribunalCase.find_by_id(session[:tribunal_case_id]) || TribunalCase.create.tap do |tribunal_case|
      session[:tribunal_case_id] = tribunal_case.id
    end
  end
  # :nocov:
end
