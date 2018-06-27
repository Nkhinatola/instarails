class User < ApplicationRecord
	has_secure_password
	has_one_attached :avatar
	has_many :posts
	has_many :likes
	has_many :relationships, foreign_key: :followed_id, dependent: :destroy
 	has_many :followers, through: :relationships

	has_many :reverse_relationships,
	 		 foreign_key: :follower_id, class_name: "Relationship", dependent: :destroy

	has_many :following, through: :reverse_relationships, 
			 source: :followed
	

	validates_presence_of :email, :username, :avatar
	validates_uniqueness_of :email, :username
	validates :password, length: {minimum: 6, maximum: 30}
	validates_email_format_of :email, message: 'The e-mail format is not correct!'
	validates :username, :password, format: { with: /\A[0-9a-zA-Z_.\-]+\Z/, message: "Only alphanumeric characters, and -_."}
	validates :username, length: {maximum: 30}

	before_create {self.email = email.downcase}
	before_create {self.username = username.downcase}	

	def follow(user)
		reverse_relationships.create(followed_id: user.id) unless following?(user)
	end
	def unfollow(user)
		reverse_relationships.where(followed_id: user.id).first.destroy if following?(user) 
	end
	def following?(user)
		reverse_relationships.where(followed_id: user.id).count > 0 
	end
	def feed
 		Post.where(user_id: following_ids.append(self.id))
	end
end