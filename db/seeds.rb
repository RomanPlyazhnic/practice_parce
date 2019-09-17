# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

GENRES = ['Action', 'Adventure', 'BL', 'Comedy', 'Drama',
        'Ecchi', 'Fantasy', 'GL', 'Harem', 'Horror',
        'Josei', 'Magical girl', 'Mecha', 'Mystery', 'Reverse Harem',
        'Romance', 'Sci Fi', 'Seinen', 'Shoujo', 'Shoujo-ai',
        'Shounen', 'Shounen-ai', 'Slice of Life', 'Sports', 'Yaoi',
        'Yuri']

GENRES.each do |genre|
    Genre.create(genre: genre).save
end