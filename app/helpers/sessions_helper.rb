module SessionsHelper
 
    def sign_in(user)
        session[:user_id] = user.id
    end
 
    def signed_in?
        !current_user.nil?
    end
  
   def current_user?(user_id)
       user_id == current_user.id if current_user
   end
 
    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end
 
 
    def sign_out
        session[:user_id] = nil
        @current_user = nil
    end
 
 end