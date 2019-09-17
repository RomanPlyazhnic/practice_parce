class Anime < ApplicationRecord
    #has_many :genre

    has_many :animegenre
    has_many :genre, through: :animegenre
end
