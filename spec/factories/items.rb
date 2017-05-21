FactoryGirl.define do
	factory :item do
		name { Faker::HeyArnold.character }
		done false
		todo_id nil
	end
end
