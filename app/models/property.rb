class Property < ApplicationRecord
    validates :name, presence: true, length: { minimum:3 }
    validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

    has_many_attached :images, dependent: :destroy do |attachable|
        attachable.variant :thumb, resize_to_limit: [350, 350]
    end
    scope :with_images, -> { order("created_at DESC")}
    # Ex:- scope :active, -> {where(:active => true)}
end
