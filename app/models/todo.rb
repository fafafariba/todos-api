class Todo < ApplicationRecord
	validates :title, :created_by, presence: true

	has_many :items, dependent: :destroy
end
