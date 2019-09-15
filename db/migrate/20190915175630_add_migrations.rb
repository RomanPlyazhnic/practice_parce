class AddMigrations < ActiveRecord::Migration[6.0]
  def change
    add_index :animes, :name
    add_index :animes, :year
    add_index :animes, :rank
    add_index :animes, :studio

    add_index :genres, :genre
  end
end
