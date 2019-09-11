class Genre < ApplicationRecord
    self.table_name = "genres"
    belongs_to :anime
end
