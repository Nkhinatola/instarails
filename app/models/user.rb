class User < ApplicationRecord
	attr_accessor :remember_token
	
	has_secure_password
	has_one_attached :avatar
	has_many :posts 	
	#validates :avatar, file_size: { less_than_or_equal_to: 200.kilobytes }, file_content_type: { allow: ['image/jpeg', 'image/png'] }
	validates_presence_of :email, :username
	validates_uniqueness_of :email, :username
	validates :password, length: {minimum: 6, maximum: 30}
	validates_email_format_of :email, message: 'The e-mail format is not correct!'
	validates :username, :password, format: { with: /\A[0-9a-zA-Z_.\-]+\Z/, message: "Only alphanumeric characters, and -_."}
	validates :username, length: {maximum: 30}
	before_create :confirmation_token
	before_create {self.email = email.downcase}
	before_create {self.username = username.downcase}
	def email_activate
    	self.email_confirmed = true
    	self.confirm_token = nil
    	save!(:validate => false)
  	end
	def User.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
     	BCrypt::Password.create(string, cost: cost)
   	end
 	def User.new_token
 		SecureRandom.urlsafe_base64
 	end
  	def remember
 		self.remember_token = User.new_token
 		update_attribute(:remember_digest, User.digest(remember_token))
 	end
 
 	def authenticated?(remember_token)
 		return false if remember_digest.nil?
 		BCrypt::Password.new(remember_digest).is_password?(remember_token)
 	end
 
 	def forget
 		update_attribute(:remember_digest, nil)
 	end
 	private
	def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end
 
end
