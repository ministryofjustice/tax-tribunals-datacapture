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
      edit_step :case_type
      edit_step :case_type_show_more
      edit_step :challenged_decision
      edit_step :challenged_decision_status
      show_step :must_challenge_hmrc
      show_step :must_wait_for_challenge_decision
      edit_step :dispute_type
      edit_step :penalty_amount
      edit_step :tax_amount
      edit_step :penalty_and_tax_amounts
    end

    namespace :hardship do
      edit_step :disputed_tax_paid
      edit_step :hardship_review_requested
      edit_step :hardship_review_status
    end

    namespace :lateness do
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
      show_step :confirmation
    end

    namespace :details do
      edit_step :taxpayer_type
      edit_step :taxpayer_details
      edit_step :has_representative
      edit_step :representative_is_legal_professional
      edit_step :representative_type
      edit_step :representative_details
      edit_step :grounds_for_appeal
      edit_step :outcome
      edit_step :documents_checklist
      show_step :check_answers
      show_step :confirmation
      edit_step :user_type
      edit_step :representative_approval
    end
  end

  resources :documents, only: [:create] do
    member do
      delete :destroy
    end
  end

  resources :appeal_cases, :closure_cases, only: [:create]

  resource :session, only: [:destroy] do
    member do
      post :create_and_fill_appeal
      post :create_and_fill_appeal_and_lateness
      post :create_and_fill_appeal_and_lateness_and_appellant
    end
  end

  resources :healthcheck, only: [:index]

  resource :errors, only: [] do
    get :case_not_found
    get :case_submitted
  end

  root to: 'home#index'
  get :appeal, to: 'home#index'
  get :start_page, to: 'home#start_page'
end
