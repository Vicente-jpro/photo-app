require "rails_helper"
RSpec.describe Property do 
    it "hes a five number" do 
        @number = Property.new
        expect(@number.five).to eq(5) 
    end
end