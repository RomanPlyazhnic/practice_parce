class SelectedGenresStorage
    class << self
        attr_accessor :hash_genres
    end

    def self.ArraySelectedGenres
        array_genres = Array.new

        @hash_genres.each do |key, value|
            array_genres.push(key) if value == "true"
        end
        
        return array_genres
    end
end