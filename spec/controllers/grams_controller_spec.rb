require 'rails_helper'

RSpec.describe GramsController, type: :controller do

	describe "grams#index action" do
		it "should successfully show index" do
			get :index
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#new action" do
		it "should successfully show new form" do
			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#create action" do
		it "should successfully create new gram in db" do
			post :create, gram: {message: 'Hello!'}
			expect(response).to redirect_to root_path
			gram = Gram.last
			expect(gram.message).to eq("Hello!")
		end
	end



end
