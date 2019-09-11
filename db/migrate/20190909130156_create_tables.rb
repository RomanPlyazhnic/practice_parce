class CreateTables < ActiveRecord::Migration[6.0]
  def change
    create_table :animes do |t|
      t.string :name
      t.timestamps
    end

    create_table :genres do |t|
      t.belongs_to :anime, index: { unique: true }, foreign_key: true
      t.boolean :senen, null: false, default: false
      t.boolean :seinen, null: false, default: false
      t.timestamps
    end
  end
end
