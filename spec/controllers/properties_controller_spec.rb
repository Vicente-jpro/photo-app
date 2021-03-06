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
          #Same instruction
          expect(assigns(:property)).to be_a_new(Property)
        end
    end


    context "GET #edit" do 
        let(:property) { create(:property) }
        it "should success and render to edit page" do 
          get :edit, params: {id: property.id}
          expect(response).to have_http_status(200) 
          expect(response).to render_template(:edit)
        end
    end


    context "CREATE #create" do 
        let!(:property) { create(:property)}

        it "should create a new property" do 
          set_property = { 
              name: property.name, 
              images: File.open(Rails.root.join('spec', 'factories', 'images', 'paca??a.jpeg'), 
              filename: 'paca??a.jpeg', 
              content_type: 'image/jpeg') 
           }
          post :create, params: { property: set_property  }
          expect(flash[:notice]).to eq("Property was successfully created.")
        end

        it "not create a new post" do 
         set_property = { 
            name: ""
          }
         post :create, params: {property: set_property}
         expect(response).to render_template("new")
        end


    end

    context "PUT #update" do 
        let(:property) { create(:property)}
        it "should update a property and notice" do
            set_property = { 
                name: property.name, 
                images:[ File.open(Rails.root.join('spec', 'factories', 'images', 'paca??a.jpeg'), 
                filename: 'paca??a.jpeg', 
                content_type: 'image/jpeg') ]
              }
         
         put :update, params: {id: property.id, property: set_property }
         property.reload

         expect(flash[:notice]).to eq("Property was successfully updated.")
         expect(response).to redirect_to(action: :show, id: assigns(:property).id)
        end

    end

    context "Destroy #destroy" do 
        let(:property) { create(:property) }

        it "Should destroy a property" do 
          delete :destroy, params: {id: property.id }
          expect(flash[:notice]).to eq("Property was successfully destroyed.")
        end
        
    end
    
    
end