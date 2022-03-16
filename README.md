# Photo-app

* Backend <br>
This application contains 1 model `Property` with a required `name` and `has many photos`
For each property, the third photo is the property cover
The photos are stored locally.
<br><br>
I used some special gems to create a database test and to clean all tests:
<br>
[factory bot rails](https://github.com/thoughtbot/factory_bot_rails); 
<br>
[database_cleaner-active_record](https://github.com/DatabaseCleaner/database_cleaner-active_record/); 
<br>
[rails-controller-testing](https://github.com/rails/rails-controller-testing).
<pre>
group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "database_cleaner-active_record"
  gem 'rails-controller-testing'
end
</pre>


## 1 - Versions
 Ruby:
<pre>ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-linux]</pre>

 Rails:
<pre>Rails 7.0.2.3
</pre>

## 2 - Model

```ruby 
class Property < ApplicationRecord
    validates :name, presence: true, length: { minimum:3 }
    has_many_attached :images, dependent: :destroy
    validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

end
```
## 3 - Controller
```ruby
class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show edit update destroy ]
  include PropertiesControllerHelper
  # GET /properties or /properties.json
  def index
    @properties = Property.all.with_attached_images
  end

  # GET /properties/1 or /properties/1.json
  def show
  end

  # GET /properties/new
  def new
    @property = Property.new
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties or /properties.json
  def create
    @property = Property.new(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to property_url(@property), notice: "Property was successfully created." }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1 or /properties/1.json
  def update
    property = property_params
    if do_not_have_image_attached?
      property = get_property(@property, property_params) 
    end
    
      respond_to do |format|
        if @property.update(property)
          format.html { redirect_to property_url(@property), notice: "Property was successfully updated." }
          format.json { render :show, status: :ok, location: @property }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @property.errors, status: :unprocessable_entity }
        end
      end
   
  end

  # DELETE /properties/1 or /properties/1.json
  def destroy
    @property.destroy

    respond_to do |format|
      format.html { redirect_to properties_url, notice: "Property was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

   def do_not_have_image_attached?
    (property_params[:images].count - 1 ) == 0
   end

    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:name, images: [])
    end
end
```

## 3 - Helpers
`helper/properties_helper.rb`
```ruby
module PropertiesHelper

    def has_more_than_two_images?(property)
       property.images.count > 2
    end

    def has_less_than_three_images?(property)
      property.images.count < 3
    end

    def display_first_image(property)
      image_tag(property.images.first)
    end

    def display_third_image(property)
      image_tag(property.images[2])
    end

end
```
`helper/properties_controller_helper.rb`
```ruby
module PropertiesControllerHelper
    def get_property(property, property_name)
        { 
          id: property.id,  
          name: property_name[:name] 
        } 
    end
end
```
## 4 - Factory
`spec/factories/property.rb`
```ruby
FactoryBot.define do 
    factory :property do 
        name {"Vicente"}
        after(:build) do |property|
            property.images.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'pacaça.jpeg')), filename: 'pacaça.jpeg', content_type: 'image/jpeg')
        end
    end
end
```
## 5 - Spec
`spec/rails_helper.rb`

```ruby
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
```

## 6 - Test
### 6.1 - Controller
`spec/controllers/properties_controller_spec.rb`

```ruby
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
              images: File.open(Rails.root.join('spec', 'factories', 'images', 'pacaça.jpeg'), 
              filename: 'pacaça.jpeg', 
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
                images:[ File.open(Rails.root.join('spec', 'factories', 'images', 'pacaça.jpeg'), 
                filename: 'pacaça.jpeg', 
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

```
### 6.2 - Model
`spec/model/property.rb`
```ruby
require "rails_helper"

RSpec.describe Property, type: :model do 
    
    let(:property){
        Property.new(
            id: 1, 
            name: "Vicente Simão"
        )
    }

    describe "Property name" do 
        it "has a name" do  
            expect(property).to be_valid
        end
        
        it "has a name at least 3 characters long" do 
            expect(property).to be_valid
        end

        it "has a name at least 2 characters long"  do 
            property.name = "Vc"
            expect(property).to_not be_valid
        end
    end
end

````
