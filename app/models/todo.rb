class Todo < ApplicationRecord
	validates :title, :created_by, presence: true
	belongs_to :user
	has_many :items, dependent: :destroy
end
