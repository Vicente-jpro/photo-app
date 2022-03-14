require "rails_helper"

RSpec.describe PropertiesController, type: :controller do 
   
    context "GET #index" do
        it "should success and render to index page" do
          get :index 
          expect(response).to have_http_status(200)
          expect(response).to render_template(:index) 
        end

        it "should have an empty array" do 
          get :index
          expect(assigns(:properties)).to be_empty
        end

        it "should not have an empty array" do 
          create(:property)   
          get :index 
          expect(assigns(:properties)).to_not be_empty 
        end

    end
    
    context "GET #Show" do 
        
        let(:property) { create(:property)}

        it "should success and render to show page" do
            get :show, params: { id: property.id }
            expect(response).to have_http_status(200)
            expect(response).to render_template(:show)
        end

        it "show where id" do 
            get :show, params: { id: property.id}
            expect(assigns(:property)).to be_a(Property)
            #Same instruction
            expect(assigns(:property)).to eq(property)
        end

    end

    context "GET #new" do 
        let(:property) {create(:property)}
        it "should success and render to new page" do 
          get :new 
          expect(response).to have_http_status(200)
          expect(response).to render_template(:new)  
        end

        it "should new post" do 
          get :new
          expect(assigns(:property)).to be_a(Property) 
        end
    end

end