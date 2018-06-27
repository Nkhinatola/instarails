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
  	resources :posts, only: [:create, :destroy]
 	#resources :likes, only: [:create]
 	post "/like", to: "likes#create"
 	delete "/unlike", to: "likes#destroy"
 	post "/follow", to: "relationships#create"
 	delete "/unfollow", to: "relationships#destroy"
end
