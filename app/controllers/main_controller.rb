require './lib/classes/PageDownloader'
require './lib/classes/Parser'
require 'byebug'
require 'kaminari'

class MainController < ApplicationController
  def index
    @genres = ['Action', 'Adventure', 'BL', 'Comedy', 'Drama',
    'Ecchi', 'Fantasy', 'GL', 'Harem', 'Horror',
    'Josei', 'Magical girl', 'Mecha', 'Mystery', 'Reverse Harem',
    'Romance', 'Sci Fi', 'Seinen', 'Shoujo', 'Shoujo-ai',
    'Shounen', 'Shounen-ai', 'Slice of Life', 'Sports', 'Yaoi',
    'Yuri']

    @selected_genres = Hash.new
    @genres.each do |genre|
      @selected_genres[genre] = params[genre]
    end

    #byebug
    parser = Parser.new
    parser.parse
    puts params[:Harem]
    order = params[:order] == nil ? :rank : params[:order].to_sym
    @animes = Anime.order(order).page params[:page]
    #@tests = Test.all    
  end
end
