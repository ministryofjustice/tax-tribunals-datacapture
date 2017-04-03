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
  devise_for :users

  namespace :steps do
    namespace :appeal do
      show_step :start
      edit_step :case_type
      edit_step :case_type_show_more
      edit_step :dispute_type
      edit_step :penalty_amount
      edit_step :tax_amount
      edit_step :penalty_and_tax_amounts
    end

    namespace :challenge do
      edit_step :decision
      edit_step :decision_status
      show_step :must_challenge_hmrc
      show_step :must_ask_for_review
      show_step :must_wait_for_challenge_decision
      show_step :must_wait_for_review_decision
    end

    namespace :hardship do
      edit_step :disputed_tax_paid
      edit_step :hardship_review_requested
      edit_step :hardship_review_status
      edit_step :hardship_reason
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
      edit_step :representative_professional_status
      edit_step :representative_type
      edit_step :representative_details
      edit_step :grounds_for_appeal
      edit_step :outcome
      edit_step :documents_checklist
      show_step :documents_upload_problems
      show_step :check_answers
      show_step :confirmation
      edit_step :user_type
      edit_step :representative_approval
    end
  end

  scope 'uploader/:document_key' do
    resources :documents, only: [:create, :destroy]
  end

  resources :appeal_cases, :closure_cases, only: [:create]

  resource :session, only: [:destroy] do
    member do
      get :ping
      post :create_and_fill_appeal
      post :create_and_fill_appeal_and_lateness
      post :create_and_fill_appeal_and_lateness_and_appellant
    end
  end

  resources :status, only: [:index]

  resource :errors, only: [] do
    get :case_not_found
    get :case_submitted
    get :unhandled
    get :not_found
  end

  root to: 'home#index'
  get :start, to: 'home#start'
  get :contact, to: 'home#contact', as: :contact_page
  get :terms_and_conditions, to: 'home#terms_and_conditions'

  # catch-all route
  # :nocov:
  match '*path', to: 'errors#not_found', via: :all, constraints:
    lambda { |_request| !Rails.application.config.consider_all_requests_local }
  # :nocov:
end
