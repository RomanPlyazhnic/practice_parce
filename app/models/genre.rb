class Genre < ApplicationRecord
    #self.table_name = "genres"
    #belongs_to :anime

    has_many :animegenre
    has_many :anime, through: :animegenre
end
