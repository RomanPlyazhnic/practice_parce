class AddColumnsToAnime < ActiveRecord::Migration[6.0]
  def change
    add_column :animes, :type, :string
    add_column :animes, :studio, :string
    add_column :animes, :year, :string
    add_column :animes, :rank, :integer
    add_column :animes, :image_href, :string
    add_column :animes, :description, :text

    add_index :animes, :name
    add_index :animes, :year
    add_index :animes, :rank
    add_index :animes, :studio
  end
end
