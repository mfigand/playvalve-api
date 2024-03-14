Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "v1/user/check_status" => "v1/users#check_status", as: :check_status
end
