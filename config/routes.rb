Rails.application.routes.draw do
	require 'sidekiq/web'
	require 'sidekiq/cron/web'
	mount Sidekiq::Web => '/sidekiq'
	resources :users, only: [:new, :create, :edit, :update]
	root 'sessions#homepage'
	get 'login', to: 'sessions#pre_login'  
	post 'login', to: 'sessions#post_login'
	get 'destroy', to: 'users#destroy'
	get 'show',  to: 'users#show_profile'
	get 'users/edit', to: 'users#edit_profile' 
	post 'edit', to: 'users#update_profile'
	post 'signup', to: 'users#create'
	post  'searchbar', to: 'admins#search_result'
	post  'get_profile', to: 'sessions#get_profile'
	get 'get_report', to: 'admins#report'

	get 'admin/edit', to: 'admins#edit'
	get 'admin/login', to: 'admins#new'
	get 'searchbar',  to: 'admins#searchbar'
	get 'admin/homepage', to: 'admins#homepage'  
	post 'admin/login', to: 'admins#create'
	get 'admin/logout', to: 'admins#logout'
end
