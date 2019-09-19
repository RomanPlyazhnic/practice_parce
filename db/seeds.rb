require './lib/classes/GenresStorage'

GenresStorage.genres.each do |genre|
    Genre.create(genre: genre).save
end