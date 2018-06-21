class SessionsController < ApplicationController
	def new
	end
	def create
		login = params[:session][:login]
		
		#puts "LOG: #{login}"
 		if login.include? "@"
			user = User.find_by_email(login)
 		else
 			user = User.find_by_username(login)
 		end
 		#puts "LOG: #{params[:session][:password]}"
 		if user && user.authenticate(params[:session][:password])
 			if user.email_confirmed
 				sign_in user
 				params[:session][:remember_me] == '1' ? remember(user) : forget(user)
 				redirect_to user
 			else
 				flash.now[:error] = 'Please activate your account by following the\n
        		instructions in the account confirmation email you received to proceed'
        		render 'new'
        	end
 		else
 			flash[:error] = "Invalid username or password"
			render "new"
 		end
	end
 
 	def destroy
 		sign_out if signed_in?
 		redirect_to root_path
 	end
end
