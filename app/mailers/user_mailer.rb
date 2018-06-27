class UserMailer < ActionMailer::Base
    default :from => "hinatolla.n@gmail.com"

 def registration_confirmation(user)
    @user = user
    mail(:to => "#{@user.username} <#{@user.email}>", :subject => "Registration Confirmation")
 end
end