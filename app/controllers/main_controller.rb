require './lib/classes/PageDownloader'
require './lib/classes/Parser'
require 'byebug'

class MainController < ApplicationController
  def index
    #byebug
    Parser.parse

    #Genre.create(seinen: true)
    #anime = Anime.create(name: "K-ON", genre: Genre.create(seinen: true))
    #anime.category.create(seinen: true)
    animes = Anime.all
    @tests = Test.all    
  end
end
