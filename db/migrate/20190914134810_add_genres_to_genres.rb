class AddGenresToGenres < ActiveRecord::Migration[6.0]
  def change
    add_column :genres, :Action, :boolean
    add_column :genres, :Adventure, :boolean
    add_column :genres, :BL, :boolean
    add_column :genres, :Comedy, :boolean
    add_column :genres, :Drama, :boolean
    add_column :genres, :Ecchi, :boolean
    add_column :genres, :Fantasy, :boolean
    add_column :genres, :GL, :boolean
    add_column :genres, :Harem, :boolean
    add_column :genres, :Horror, :boolean
    add_column :genres, :Josei, :boolean
    add_column :genres, :Magical_girl, :boolean
    add_column :genres, :Mecha, :boolean
    add_column :genres, :Mystery, :boolean
    add_column :genres, :Reverse_Harem, :boolean
    add_column :genres, :Romance, :boolean
    add_column :genres, :Sci_Fi, :boolean
    add_column :genres, :Seinen, :boolean
    add_column :genres, :Shoujo, :boolean
    add_column :genres, :Shoujo_ai, :boolean
    add_column :genres, :Shounen, :boolean
    add_column :genres, :Shounen_ai, :boolean
    add_column :genres, :Slice_of_Life, :boolean
    add_column :genres, :Sports, :boolean
    add_column :genres, :Yaoi, :boolean
    add_column :genres, :Yuri, :boolean

    add_index :genres, :Action
    add_index :genres, :Adventure
    add_index :genres, :BL
    add_index :genres, :Comedy
    add_index :genres, :Drama
    add_index :genres, :Ecchi
    add_index :genres, :Fantasy
    add_index :genres, :GL
    add_index :genres, :Harem
    add_index :genres, :Horror
    add_index :genres, :Josei
    add_index :genres, :Magical_girl
    add_index :genres, :Mecha
    add_index :genres, :Mystery
    add_index :genres, :Reverse_Harem
    add_index :genres, :Romance
    add_index :genres, :Sci_Fi
    add_index :genres, :Seinen
    add_index :genres, :Shoujo
    add_index :genres, :Shoujo_ai
    add_index :genres, :Shounen
    add_index :genres, :Shounen_ai
    add_index :genres, :Slice_of_Life
    add_index :genres, :Sports
    add_index :genres, :Yaoi
    add_index :genres, :Yuri
  end
end
