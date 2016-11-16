class ActionDispatch::Routing::Mapper
  def edit_update_step(name)
    resource name,
             only:       [:edit, :update],
             controller: name,
             path_names: { edit: '' }
  end

  def show_step(name)
    resource name,
             only:       [:show],
             controller: name
  end
end

Rails.application.routes.draw do
  namespace :steps do
    namespace :cost do
      show_step        :start
      edit_update_step :challenged_decision
      edit_update_step :case_type_challenged
      edit_update_step :case_type_unchallenged
      edit_update_step :dispute_type
      edit_update_step :penalty_amount
      show_step        :determine_cost
      show_step        :must_challenge_hmrc
    end
  end

  resource :session, only: [:destroy]
  root to: 'start#index'
end
