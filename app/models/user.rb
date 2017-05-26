class User < ApplicationRecord
	has_secure_password
	has_many :todos, foreign_key: :created_by
	validates :name, :email, :password_digest, presence: true
	# validates :email, uniqueness: true
end
