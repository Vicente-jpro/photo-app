class Property < ApplicationRecord
    validates :name, presence: true
    has_many_attached :images 
    validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }
    
    def five 
        5
    end 
end
