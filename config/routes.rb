Rails.application.routes.draw do
	get "/contact", to: "pages#contact"
	get "/about", to: "pages#about"
	root "pages#index"
	resources :users
	get "/login", to: "sessions#new"
	post "/login", to: "sessions#create"
	get "/signup", to: "users#new"
	delete "/logout", to: "sessions#destroy"
	resources :users do
    	member do
      		get :confirm_email
    	end
  	end
end
