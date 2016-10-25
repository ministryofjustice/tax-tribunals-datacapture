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
  end

  root to: 'start#index'
end
