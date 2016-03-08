FactoryGirl.define do

	factory :user do
		sequence :email do |n|
			"test#{n}@gmail.com"
		end
		password "testtest"
		password_confirmation "testtest"
	end

	factory :gram do
		message "hello"
		association :user
	end
end
