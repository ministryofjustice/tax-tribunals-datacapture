Rails.application.routes.draw do
  namespace :steps do
    [
      :did_challenge_hmrc
    ].each do |ctrlr|
      resources ctrlr, only: [:edit, :update]
    end
  end
end
