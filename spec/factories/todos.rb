FactoryGirl.define do
	factory :todo do
		title { Faker:: Food.ingredient }
		created_by { Faker::Number.number(10) }
	end
end