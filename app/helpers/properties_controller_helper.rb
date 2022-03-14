module PropertiesControllerHelper
    def get_property(property, property_name)
        { 
          id: property.id,  
          name: property_name[:name] 
        } 
    end
end