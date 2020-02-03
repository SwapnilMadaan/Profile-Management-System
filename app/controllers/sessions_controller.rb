class SessionsController < ApplicationController
		
#		skip_before_action :authorized, only: [:pre_login, :post_login, :homepage, :get_profile]

		def pre_login	  
		end

		def post_login  
			@user = User.find_by(user_email: params[:username])
			if @user && @user.authenticate(params[:password])
				session[:user_id] = @user.id
				Rails.cache.write(@user.id,@user)
				redirect_to root_path
			else
				render json: {title: "Paramters Not Matched",
				 status: 404
				}
			end
  	end

		def login
		end
		
		def homepage

			#if admin_logged_in
			#	redirect_to admin_homepage_path
			#end

	  end

		def get_profile
			if(params[:profile_id])
				if Rails.cache.read(params[:profile_id])
						@user = Rails.cache.read(params[:profile_id])
				else
						@user = User.find_by(id: params[:profile_id])
				end
				if @user
						render json: {
						profile_id: @user.id,
						name: @user.user_name,
						email: @user.user_email,
						contact: @user.user_contact,
						user_type:   @user.user_catagory,
						response: "200",
						message: "API run successfully"}
				else
				render json: {
										response: "404",
										message: "User Not Found"}
				end
				else
				render json: {
					response: "500",
					message: "Paramters not given"}
				end
		end
  
	def page_requires_login
  
  end
  


end
