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
end