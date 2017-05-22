class User < ApplicationRecord
	validates :name, :email, :password_digest, presence: true
	validates :email, uniqueness: true

	has_secure_password

	has_many :todos, foreign_key: :created_by
end
