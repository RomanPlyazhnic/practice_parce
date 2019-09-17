require './lib/classes/PageDownloader'
require './lib/classes/Parser'
require './lib/classes/SelectedGenresStorage'
require 'byebug'
require 'kaminari'

class MainController < ApplicationController
  def index
    #Parser.new.parse

    @genres = ['Action', 'Adventure', 'BL', 'Comedy', 'Drama',
    'Ecchi', 'Fantasy', 'GL', 'Harem', 'Horror',
    'Josei', 'Magical girl', 'Mecha', 'Mystery', 'Reverse Harem',
    'Romance', 'Sci Fi', 'Seinen', 'Shoujo', 'Shoujo-ai',
    'Shounen', 'Shounen-ai', 'Slice of Life', 'Sports', 'Yaoi',
    'Yuri']

    if SelectedGenresStorage.hash_genres == nil
      SelectedGenresStorage.hash_genres = Hash.new
    end
    
    #if params[:commit] == "Поиск"
    #  SelectedGenresStorage.hash_genres = Hash.new

    #  @genres.each do |genre|
    #    SelectedGenresStorage.hash_genres[genre] = params[genre]
    #  end
    #end

    @selected_genres = SelectedGenresStorage.hash_genres
    order = params[:order] == nil ? :rank : params[:order].to_sym
    @animes = Anime.order(order)

    if !SelectedGenresStorage.ArraySelectedGenres.empty?
      search_query = "name in (
        select animes.name from animes
        join animegenres on animes.id = animegenres.anime_id
        join genres on animegenres.genre_id = genres.id
        where genres.genre in #{SelectedGenresStorage.ArraySelectedGenres}
        group by name having count(*) = #{SelectedGenresStorage.ArraySelectedGenres.length}
        order by animes.name)".gsub(/\[/, '(').gsub(/]/, ')').gsub(/"/, '\'')
      @animes = @animes.where(search_query)      
    end

    @animes = @animes.page params[:page]
  end

  def search
    #Parser.new.parse

    @genres = ['Action', 'Adventure', 'BL', 'Comedy', 'Drama',
    'Ecchi', 'Fantasy', 'GL', 'Harem', 'Horror',
    'Josei', 'Magical girl', 'Mecha', 'Mystery', 'Reverse Harem',
    'Romance', 'Sci Fi', 'Seinen', 'Shoujo', 'Shoujo-ai',
    'Shounen', 'Shounen-ai', 'Slice of Life', 'Sports', 'Yaoi',
    'Yuri']

    if SelectedGenresStorage.hash_genres == nil
      SelectedGenresStorage.hash_genres = Hash.new
    end

    SelectedGenresStorage.hash_genres = Hash.new

    @genres.each do |genre|
      SelectedGenresStorage.hash_genres[genre] = params[genre]
    end    

    @selected_genres = SelectedGenresStorage.hash_genres
    order = params[:order] == nil ? :rank : params[:order].to_sym
    @animes = Anime.order(order)

    if !SelectedGenresStorage.ArraySelectedGenres.empty?
      search_query = "name in (
        select animes.name from animes
        join animegenres on animes.id = animegenres.anime_id
        join genres on animegenres.genre_id = genres.id
        where genres.genre in #{SelectedGenresStorage.ArraySelectedGenres}
        group by name having count(*) = #{SelectedGenresStorage.ArraySelectedGenres.length}
        order by animes.name)".gsub(/\[/, '(').gsub(/]/, ')').gsub(/"/, '\'')
      @animes = @animes.where(search_query)      
    end

    @animes = @animes.page params[:page]
  end
end
