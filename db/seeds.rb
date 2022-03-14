# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

(1..50).each do |number|
    @property = Property.new
    @property.name = "Nature #{number}"
    @property.images.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'pacaça.jpeg')), filename: 'pacaça.jpeg', content_type: 'image/jpeg')
    @property.save
end

#app/assets/images/pacaça.jpeg
