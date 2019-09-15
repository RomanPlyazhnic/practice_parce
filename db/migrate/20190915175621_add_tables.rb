class AddTables < ActiveRecord::Migration[6.0]
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
      t.belongs_to :anime, index: { unique: false }, foreign_key: true
      t.string :genre
      t.timestamps
    end
  end
end
