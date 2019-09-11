require './lib/classes/PageDownloader'
require './lib/classes/ParseManager'
require './lib/classes/Parser'
require 'byebug'

class MainController < ApplicationController
  def index
    #byebug
    href = "https://www.anime-planet.com/anime/all?page="
    page_downloader = PageDownloader.new
    parser = Parser.new
    parse_manager = ParseManager.new(page_downloader, parser, href)
    parse_manager.execute

    #Genre.create(seinen: true)
    #anime = Anime.create(name: "K-ON", genre: Genre.create(seinen: true))
    #anime.category.create(seinen: true)
    @tests = Test.all
    animes = Anime.all
  end
end
