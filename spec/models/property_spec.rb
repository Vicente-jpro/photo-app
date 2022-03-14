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