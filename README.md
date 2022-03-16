# Photo-app

* Backend <br>
This application contains 1 model `Property` with a required `name` and `has many photos`
For each property, the third photo is the property cover
The photos are stored locally.
<br><br>
I used some special gems to create a database test and to clean all tests:
<br>
[factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails); 
<br>
[database_cleaner-active_record](https://github.com/DatabaseCleaner/database_cleaner-active_record); 
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

```ruby
module PropertiesControllerHelper
    def get_property(property, property_name)
        { 
          id: property.id,  
          name: property_name[:name] 
        } 
    end
end
``````````````````````````````````
