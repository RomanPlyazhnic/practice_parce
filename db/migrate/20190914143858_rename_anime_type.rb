class RenameAnimeType < ActiveRecord::Migration[6.0]
  def change
    rename_column :animes, :type, :kind
  end
end
