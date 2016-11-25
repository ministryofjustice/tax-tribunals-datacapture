class ActionDispatch::Routing::Mapper
  def edit_step(name)
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
      show_step :start
      edit_step :challenged_decision
      edit_step :case_type_challenged
      edit_step :case_type_unchallenged
      edit_step :dispute_type
      edit_step :penalty_amount
      show_step :determine_cost
      show_step :must_challenge_hmrc
    end

    namespace :lateness do
      show_step :start
      edit_step :in_time
      edit_step :lateness_reason
    end

    namespace :details do
      show_step :start
    end
  end

  resource :session, only: [:destroy]
  root to: 'home#index'
end
