require 'rails_helper'

RSpec.describe GramsController, type: :controller do

	describe "grams#index action" do
		it "should successfully show index" do
			get :index
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#new action" do
		it "should require user to be logged in" do
			get :new
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully show new form" do
			user = FactoryGirl.create(:user)
			sign_in user
			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#create action" do
		it "should require user to be logged in" do
			post :create, gram: { message: "Hello" }
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully create new gram in db" do
			user = FactoryGirl.create(:user)
			sign_in user

			post :create, gram: { message: 'Hello!' }
			expect(response).to redirect_to root_path
			gram = Gram.last
			expect(gram.message).to eq("Hello!")
			expect(gram.user).to eq(user)
		end

		it "should properly validate errors" do
			user = FactoryGirl.create(:user)
			sign_in user

			post :create, gram: { message: '' }
			expect(response).to have_http_status(:unprocessable_entity)
			expect(Gram.count).to eq 0
		end
	end

	describe "grams#show action" do
		it "should successfully show page if gram is found" do
			gram = FactoryGirl.create(:gram)
			get :show, id: gram.id
			expect(response).to have_http_status(:success)
		end

		it "should return 404 error if gram is not found" do
			get :show, id: 'TACOCAT'
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "grams#edit" do
		it "should not allow user who is not creator to edit" do
			gram = FactoryGirl.create(:gram)
			user = FactoryGirl.create(:user)
			sign_in user
			get :edit, id: gram.id
			expect(response).to have_http_status(:forbidden)
		end

		it "should not allow unauthenticated users access to edit" do
			gram = FactoryGirl.create(:gram)
			get :edit, id: gram.id
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully show edit form if gram found" do
			gram = FactoryGirl.create(:gram)
			sign_in gram.user
			get :edit, id: gram.id
			expect(response).to have_http_status(:success)
		end

		it "should return 404 error if gram is not found" do
			user = FactoryGirl.create(:user)
			sign_in user
			get :edit, id: 'TACOCAT'
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "grams#update" do
		it "should not allow user who is not creator to update" do
			gram = FactoryGirl.create(:gram)
			user = FactoryGirl.create(:user)
			sign_in user
			patch :update, id: gram.id, gram: { message: 'Hello now' }
			expect(response).to have_http_status(:forbidden)
		end

		it "should not allow unauthenticated users to update" do
			gram = FactoryGirl.create(:gram)
			patch :update, id: gram.id, gram: { message: 'Hello now' }
			expect(response).to redirect_to new_user_session_path
		end

		it "should allow user to successfully update grams" do
			gram = FactoryGirl.create(:gram, message: 'Initial value')
			sign_in gram.user
			patch :update, id: gram.id, gram: { message: 'Changed' }
			expect(response).to redirect_to root_path
			gram.reload
			expect(gram.message).to eq "Changed"
		end

		it "should have 404 error if gram not found" do
			user = FactoryGirl.create(:user)
			sign_in user
			patch :update, id: 'TACOCAT', gram: { message: 'Changed' }
			expect(response).to have_http_status(:not_found)
		end

		it "should render edit form with status of unprocessable_entity" do
			gram = FactoryGirl.create(:gram, message: 'Initial value')
			sign_in gram.user
			patch :update, id: gram.id, gram: { message: '' }
			expect(response).to have_http_status(:unprocessable_entity)
			gram.reload
			expect(gram.message).to eq "Initial value"
		end
	end

	describe "grams#destroy" do
		it "should not allow user who is not creator to destroy" do
			gram = FactoryGirl.create(:gram)
			user = FactoryGirl.create(:user)
			sign_in user
			delete :destroy, id: gram.id
			expect(response).to have_http_status(:forbidden)
		end

		it "should not allow unauthenticated users to destroy" do
			gram = FactoryGirl.create(:gram)
			delete :destroy, id: gram.id
			expect(response).to redirect_to new_user_session_path
		end

		it "should allow user to destroy gram" do
			gram = FactoryGirl.create(:gram)
			sign_in gram.user
			delete :destroy, id: gram.id
			expect(response).to redirect_to root_path
			gram = Gram.find_by_id(gram.id)
			expect(gram).to eq nil
		end

		it "should return 404 error if no gram found with id specified" do
			user = FactoryGirl.create(:user)
			sign_in user
			delete :destroy, id: 'TACOCAT'
			expect(response).to have_http_status(:not_found)
		end
	end


end
