class ApplicationController < ActionController::Base
	#before_action :authorized
	helper_method :current_user
	helper_method :logged_in
	helper_method :admin_logged_in

	helper_method :find_admin
	 
	def current_user 
		User.find_by(id: session[:user_id])
	end
	
	def logged_in
		!current_user.nil?
	end

	def authorized
		#if  !(admin_logged_in)
		#	byebug
		#	redirect_to admin_homepage_path
		if !logged_in
			redirect_to root_path
		end
	end
	
  	def admin_logged_in
  		!find_admin.nil?
  	end
  	
  	def find_admin
  		Admin.find_by(id: session[:admin_id])
  	end
end
	