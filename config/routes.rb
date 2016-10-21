Rails.application.routes.draw do
  namespace :steps do
    [
      :hmrc_challenge
    ].each do |ctrlr|
      resources ctrlr, only: [:edit, :update]
    end
  end
end
