class Property < ApplicationRecord
    validates :name, presence: true, length: { minimum:3 }
    has_many_attached :images, dependent: :destroy
    validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }
    
end
