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
    end

    namespace :lateness do
      show_step :start
      edit_step :in_time
      edit_step :lateness_reason
    end

    namespace :details do
      show_step :start
      edit_step :taxpayer_type
      edit_step :individual_details
      edit_step :company_details
      edit_step :grounds_for_appeal
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

  resources :case_details, only: [:index] do
    collection do
      get :test_upload
    end
  end

  resource :session, only: [:destroy] do
    member do
      post :create_and_fill_cost
      post :create_and_fill_cost_and_lateness
    end
  end
  root to: 'home#index'
end
