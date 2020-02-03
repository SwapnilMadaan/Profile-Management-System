class AdminsController < ApplicationController
	#skip_before_action :authorized, only: [:new, :create, :signup_params, :homepage, :searchbar , :search_result, :logout,:edit, :update, :report]
	def new
  		@admin = Admin.new
  	end

  	def create  
    	@admin = Admin.find_by(name: params[:name])
    	if @admin && @admin.authenticate(params[:password])
			session[:admin_id] = @admin.id
			redirect_to admin_homepage_path
    	else
			render plain: "not successful"
		end
    end

  	def login
  	end

  	def homepage  
  	end

  	def edit
		@user = User.find_by(id: params[:format])
	end
  
	def search_result
		if params[:query].nil? || params[:field].nil?
   			render json: {title: "params not provided",
			status_code: 404}
		else
			@users = User.es_search_result(params)
		end
	end

	def update
		@user = User.find(params[:user_id])
		byebug
		if @user.update(user_param)
			redirect_to admin_homepage_path
		else
			render json: @user.errors
		end
	end

	def report
		render file: 'daily_user_report.txt', layout: false, content_type: 'text/plain'
	end

  
  	def logout  
    	session[:admin_id] = nil  
    	redirect_to root_path  
  	end  
  	
  	def searchbar
  	end


  	private
	def user_param
		params.require(:user).permit(:user_id, :user_name, :password, :user_contact, :parent_id , :user_catagory, )
	end

end
