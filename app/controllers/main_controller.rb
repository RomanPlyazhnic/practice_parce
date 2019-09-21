require './lib/classes/PageDownloader'
require './lib/classes/Parser'
require './lib/classes/GenresStorage'
require 'kaminari'

class MainController < ApplicationController
  helper QueryHelper

  def index
    @genres = GenresStorage.genres
    @animes = anime_selector(@animes, params)
  end

  def search
    @genres = GenresStorage.genres
    @animes = anime_selector(@animes, params, true)
    render :index
  end

  def parse
    Parser.new.parse
    redirect_to :action => "index"
  end

  private 

  def anime_selector(animes, params, search = false)
    @selected_genres = Hash.new

    @genres.each do |genre|
      @selected_genres[genre] = params[genre]
    end
    
    order = params[:order] == nil ? :rank : params[:order].to_sym
    animes = Anime.order(order)

    if params[:search_field] != nil
      animes = animes.where("lower(name) LIKE  lower('%#{params[:search_field]}%')")
    end

    if !array_selected_genres(@selected_genres).empty?
      
      animes = animes.where("name in (
        select animes.name from animes
        join animegenres on animes.id = animegenres.anime_id
        join genres on animegenres.genre_id = genres.id
        where genres.genre in (?)
        group by name having count(*) = ?
        order by animes.name)",
        array_selected_genres(@selected_genres), array_selected_genres(@selected_genres).length)      
    end

    animes = animes.page(params[:page])
  end

  def array_selected_genres(hash)
    array_genres = Array.new

    hash.each do |key, value|
        array_genres.push(key) if value == "true"
    end
    
    return array_genres
  end
end
