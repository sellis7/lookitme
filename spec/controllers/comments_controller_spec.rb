require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	describe "comments#create action" do
		it "should allow user to create comment on gram" do
			gram = FactoryGirl.create(:gram)
			user = FactoryGirl.create(:user)
			sign_in user
			post :create, gram_id: gram.id, comment: { message: 'love!' }
			expect(response).to redirect_to root_path
			expect(gram.comments.length).to eq 1
			expect(gram.comments.first.message).to eq "love!"
		end

		it "should require user to be logged in to comment" do
			gram = FactoryGirl.create(:gram)
			post :create, gram_id: gram.id, comment: { message: 'love!' }
			expect(response).to redirect_to new_user_session_path
		end

		it "should return 404 not found if gram not located" do
			user = FactoryGirl.create(:user)
			sign_in user
			post :create, gram_id: 'TACOCAT', comment: { message: 'love!' }
			expect(response).to have_http_status :not_found
		end

	end

end
