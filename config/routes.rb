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
    namespace :appeal do
      show_step :start
      edit_step :challenged_decision
      edit_step :case_type
      edit_step :case_type_show_more
      edit_step :dispute_type
      edit_step :penalty_amount
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
      edit_step :case_type
      edit_step :enquiry_details
      edit_step :additional_info
      edit_step :support_documents
      show_step :check_answers
    end

    namespace :details do
      show_step :start
      edit_step :taxpayer_type
      edit_step :taxpayer_details
      edit_step :has_representative
      edit_step :representative_type
      edit_step :representative_details
      edit_step :grounds_for_appeal
      edit_step :outcome
      edit_step :documents_checklist
      show_step :check_answers
      edit_step :user_type
    end
  end

  resources :documents, only: [:create] do
    member do
      delete :destroy
    end
  end

  resources :cases, only: [:create, :show]

  resource :session, only: [:destroy] do
    member do
      post :create_and_fill_appeal
      post :create_and_fill_appeal_and_lateness
      post :create_and_fill_appeal_and_lateness_and_appellant
    end
  end

  resources :healthcheck, only: [:index]

  root to: 'home#index'
  get :appeal, to: 'home#index'
end
