FactoryBot.define do 
    factory :property do 
        name {"Vicente"}
        after(:build) do |property|
            property.images.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'pacaça.jpeg')), filename: 'pacaça.jpeg', content_type: 'image/jpeg')
        end
    end
end