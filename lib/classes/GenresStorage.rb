class GenresStorage
    @genres = ['Action', 'Adventure', 'BL', 'Comedy', 'Drama',
    'Ecchi', 'Fantasy', 'GL', 'Harem', 'Horror',
    'Josei', 'Magical girl', 'Mecha', 'Mystery', 'Reverse Harem',
    'Romance', 'Sci Fi', 'Seinen', 'Shoujo', 'Shoujo-ai',
    'Shounen', 'Shounen-ai', 'Slice of Life', 'Sports', 'Yaoi',
    'Yuri']

    class << self
        attr_reader :genres
    end

    def self.HashSelectedGenres
        return @hash_selected_genres == nil ? Hash.new : @hash_selected_genres
    end

    def self.ResetHashSelectedGenres
        @hash_selected_genres = Hash.new
    end

    def self.ArraySelectedGenres
        array_genres = Array.new

        self.HashSelectedGenres.each do |key, value|
            array_genres.push(key) if value == "true"
        end
        
        return array_genres
    end
end