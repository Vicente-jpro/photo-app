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
