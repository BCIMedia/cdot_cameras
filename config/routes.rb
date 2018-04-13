Rails.application.routes.draw do
  namespace :cdot_camera do
    root to: "pages#home"
    resources :camera_views
    resources :cameras
  end
end
