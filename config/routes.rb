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
      edit_step :case_type
      edit_step :case_type_show_more
      edit_step :dispute_type
      edit_step :penalty_amount
      show_step :determine_cost
      show_step :must_challenge_hmrc
      edit_step :tax_amount
      edit_step :challenged_decision_status
      edit_step :penalty_and_tax_amounts
    end

    namespace :hardship do
      edit_step :disputed_tax_paid
      edit_step :hardship_review_requested
      edit_step :hardship_review_status
    end

    namespace :lateness do
      show_step :start
      edit_step :in_time
      edit_step :lateness_reason
    end

    namespace :closure do
      show_step :start
    end

    namespace :details do
      show_step :start
      edit_step :taxpayer_type
      edit_step :individual_details
      edit_step :organisation_details
      edit_step :grounds_for_appeal
      edit_step :outcome
      edit_step :documents_checklist
      show_step :check_answers
    end
  end

  resources :documents, only: [:create] do
    member do
      delete :destroy
    end
  end

  resources :cases, only: [:create]

  resource :session, only: [:destroy] do
    member do
      post :create_and_fill_cost
      post :create_and_fill_cost_and_lateness
      post :create_and_fill_cost_and_lateness_and_appellant
    end
  end

  resources :healthcheck, only: [:index]

  root to: 'home#index'
  get :task_list, to: 'task_list#index'
end
