class TablesCreate < ActiveRecord::Migration[6.0]
  def change
    create_table :animes do |t|
      t.string :name
      t.string :kind
      t.string :studio
      t.string :year
      t.integer :rank
      t.string :image_href
      t.text :description
      t.timestamps
    end

    create_table :genres do |t|
      t.string :genre
      t.timestamps
    end

    create_table :animegenres do |t|
      t.belongs_to :anime
      t.belongs_to :genre
      t.timestamps
    end
  end
end
