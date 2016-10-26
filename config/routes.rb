STEPS = [
  :did_challenge_hmrc
]

Rails.application.routes.draw do
  namespace :steps do
    STEPS.each do |step_resource|
      resource step_resource,
        only:       [:edit, :update],
        controller: step_resource,
        path_names: { edit: '' }
    end

    resource :determine_cost,
      only: [:show],
      controller: :determine_cost
  end

  resource :session, only: [:destroy]
  root to: 'start#index'
end
