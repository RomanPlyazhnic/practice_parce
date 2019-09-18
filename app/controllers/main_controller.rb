require './lib/classes/PageDownloader'
require './lib/classes/Parser'
require './lib/classes/GenresStorage'
require 'byebug'
require 'kaminari'

class MainController < ApplicationController
  def index
    @genres = GenresStorage.genres
    @animes = AnimeSelector(@animes, params)
  end

  def search
    #Parser.new.parse
    @genres = GenresStorage.genres
    @animes = AnimeSelector(@animes, params, true)
    render :index
  end

  def parse
    Parser.new.parse
    redirect_to :action => "index"
  end
  
  private 

  def AnimeSelector(animes, params, search = false)
    ReselectGenres(params) if search

    @selected_genres = GenresStorage.HashSelectedGenres
    order = params[:order] == nil ? :rank : params[:order].to_sym
    animes = Anime.order(order)

    if params[:search_field] != nil
      animes = animes.where("lower(name) LIKE  lower('%#{params[:search_field]}%')")
    end

    if !GenresStorage.ArraySelectedGenres.empty?
      search_query = "name in (
        select animes.name from animes
        join animegenres on animes.id = animegenres.anime_id
        join genres on animegenres.genre_id = genres.id
        where genres.genre in #{GenresStorage.ArraySelectedGenres}
        group by name having count(*) = #{GenresStorage.ArraySelectedGenres.length}
        order by animes.name)".gsub(/\[/, '(').gsub(/]/, ')').gsub(/"/, '\'')
      animes = animes.where(search_query)      
    end

    animes = animes.page(params[:page])
  end

  def ReselectGenres(params)
    GenresStorage.ResetHashSelectedGenres

    @genres.each do |genre|
      GenresStorage.HashSelectedGenres[genre] = params[genre]
    end   
  end
end
