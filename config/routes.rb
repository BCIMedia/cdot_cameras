CdotCamera::Engine.routes.draw do
  resources :camera_views
  root to: "pages#home"
  resources :cameras
end
