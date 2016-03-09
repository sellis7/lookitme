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
		picture { fixture_file_upload( Rails.root + 'spec/fixtures/picture.jpg', 'image/jpg') }
		association :user
	end

	factory :picture do
		picture { fixture_file_upload( Rails.root + 'spec/fixtures/picture.jpg') }
	end
end
