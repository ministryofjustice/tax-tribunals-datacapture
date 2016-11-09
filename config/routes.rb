STEPS = %i(
  did_challenge_hmrc
  case_type_challenged
  case_type_unchallenged
  what_is_dispute_about
  what_is_late_penalty_or_surcharge
)

ENDPOINTS = %i(
  determine_cost
  must_challenge_hmrc
)

Rails.application.routes.draw do
  namespace :steps do
    STEPS.each do |step_resource|
      resource step_resource,
        only:       [:edit, :update],
        controller: step_resource,
        path_names: { edit: '' }
    end

    ENDPOINTS.each do |endpoint_resource|
      resource endpoint_resource,
        only:       [:show],
        controller: endpoint_resource
    end
  end

  resource :session, only: [:destroy]
  root to: 'start#index'
end
