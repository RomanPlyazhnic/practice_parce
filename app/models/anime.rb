class Anime < ApplicationRecord
    has_many :genre
    #include ActiveModel::Model
    #attr_accessor :name, :kind, :studio, :year, :rank, :description, :genre, :image_href
end
