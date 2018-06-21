class UsersController < ApplicationController
	def index 
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
			
		if @user.save
			UserMailer.registration_confirmation(@user).deliver
        	flash[:success] = "Please confirm your email address to continue"
        	redirect_to root_url
		else
			render :new
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)		
 	    	flash[:success] = "Profile updated"
    	   	redirect_to @user
 	   	else
 	   		flash[:error] = "Invalid username or email or password"
			render 'edit'
  	   	end
	end

	def destroy()
		user = User.find(params[:id])
		user.destroy
 		redirect_to users_path
	end
	def confirm_email
	    user = User.find_by_confirm_token(params[:id])
	    if user
		    user.email_activate
		    flash[:success] = "Welcome to the Instagram! Your email has been confirmed.
		    Please sign in to continue."
		    redirect_to signin_url
	    else
	        flash[:error] = "Sorry. User does not exist"
	        redirect_to root_url
		end
	end

	private

	def user_params
		params.require(:user).permit(:id, :username, :email, :password, :avatar)
	end

end
