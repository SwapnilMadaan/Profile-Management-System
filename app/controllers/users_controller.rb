class UsersController < ApplicationController
	#skip_before_action :authorized, only: [:new, :create, :signup_params]	
	def new   
		@user = User.new
	end

	def edit
		byebug
		@user = User.find_by(id: session[:user_id])
	end

	def show_profile
		if Rails.cache.read(session[:user_id])
			@user = Rails.cache.read(session[:user_id])
		else
			@user = User.find_by(id: session[:user_id])
		end
		render json: {
						 profile_id: @user.id,
						 name: @user.user_name,
						 email: @user.user_email, 
						 contact: @user.user_contact, 
						 response: "200", 
						 message: " User Profile"}
	end	

	def update
		@user = User.find(session[:user_id])
		if @user.update(user_param)
			redirect_to root_path
		else
			render json: @user.errors
		end
	end

	def destroy
		session[:user_id]=nil
		redirect_to root_path
	end

	def create
			@user = User.new(params.require(:user).permit(:user_name, :password, :user_contact, :user_email, :user_catagory, :parent_id ))
			if @user.save
				session[:user_id] = @user.id
				redirect_to root_path	
			else		
				render json: @user.errors
			end
	end

	def self.search_record(params)
		return es_search_result(params)
	end



	def user_param
		params.require(:user).permit(:user_name, :password, :user_contact, :user_email, :user_catagory, :parent_id )
	end


end