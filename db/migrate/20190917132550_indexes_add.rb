class IndexesAdd < ActiveRecord::Migration[6.0]
  def change
    add_index :animes, :name
    add_index :animes, :year
    add_index :animes, :rank
    add_index :animes, :studio
  end
end
