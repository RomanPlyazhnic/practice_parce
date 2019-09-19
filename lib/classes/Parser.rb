require 'nokogiri'
require 'em-http-request'
require 'eventmachine'

class Parser
    MAIN_HREF = 'https://www.anime-planet.com'
    COUNT_PROCESS = 4

    def parse()        
        # очистка таблиц
        Anime.delete_all
        Animegenre.delete_all
        # -----
        @count_pages = searchCountPages("#{MAIN_HREF}/anime/all?page=1")          
        @count_pages = 2
        count_pages_for_process = @count_pages / 4
        
        searchPages(count_pages_for_process)

        Process.waitall
    end

    private

    def searchCountPages(href)
        begin
            page = PageDownloader.new.download(href)
       
            if page.nil?
                return 0
            else                
                el_count_pages = page.xpath("//div[@class='pagination aligncenter']//li[last() - 1]/a").first
                count_pages = el_count_pages.content.to_i
                return count_pages
            end
        rescue StandardError => err
            Rails.logger.error(err)
        end
    end

    def searchPages(count_pages_for_process)
        for num_proc in (1..COUNT_PROCESS) do 
            fork do            
                threads = []  

                for i in (0..count_pages_for_process)
                    num_page = (4 * i) + num_proc
                    href = "#{MAIN_HREF}/anime/all?page=#{num_page}"

                    threads << Thread.new(href, num_page) do |h, n|
                        searchAnimesInPage(h, n)
                    end
                end

                threads.each do |t|
                    t.join
                end                            
            end
        end
    end
    
    def searchAnimesInPage(href, num_page)
        Thread.current.exit if num_page > @count_pages
        page_downloader = PageDownloader.new
        page = page_downloader.download(href)

        begin
            anime_links = page.xpath("//ul[@class='cardDeck cardGrid']//li//a")
        rescue StandardError => err
            Rails.logger.error(err)
        end

        EM.run {
            multi = EM::MultiRequest.new

            j = 0
            anime_links.each do |anime_link|
                begin 
                    j = j + 1
                    href = "#{MAIN_HREF}#{anime_link.attr('href')}"
                    http = EM::HttpRequest.new(href).get

                    http.callback {
                        writeAnime(Nokogiri::HTML(http.response))
                    }

                    http.errback {p 'Error loading page'; EM.stop}

                    multi.add j, http
                rescue StandardError => err
                    Rails.logger.error(err)
                end
            end

            multi.callback {
                p multi.responses[:callback].size
                p multi.responses[:errback].size
                EM.stop
            }
        } 
    end

    def writeAnime(anime_page)
        reg_rank = /\d+/m
        top_section = anime_page.xpath("//section[@class='pure-g entryBar']")
        main_section = anime_page.xpath("//div[@class='pure-g entrySynopsis']")
        anime = Anime.create

        # название
        name_dom = anime_page.xpath("//h1[@itemprop='name']")

        if name_dom != nil
            anime.name = name_dom.first.content
        else
            return
        end

        # тип
        kind_dom = top_section.xpath("//span[@class='type']")

        if kind_dom != nil
            anime.kind = kind_dom.first.content
        end
        
        # студия
        studio_dom = top_section.xpath("//div[@class='pure-1 md-1-5'][position()=1]")

        if studio_dom != nil
            anime.studio = studio_dom.first.content.strip
        end
        
        # год
        year_dom = top_section.xpath("//div[@class='pure-1 md-1-5']/span[@class='iconYear']")

        if year_dom != nil
            anime.year = year_dom.first.content.strip
        end
        
        # ранг
        rank_dom = top_section.xpath("//div[@class='pure-1 md-1-5']")
        
        if rank_dom != nil
            anime.rank = rank_dom.last.content.scan(reg_rank).first
        end

        # жанры
        found_genres = Array.new
        genres_dom = main_section.xpath("//li[@itemprop='genre']/a")

        if genres_dom != nil
            genres_dom.each do |genre_dom|
                genre = genre_dom.content.strip

                found_genres.push(genre) if GenresStorage.genres.include?(genre)
            end

            found_genres.each do |genre|
                anime.genre << Genre.where(genre: genre)
            end
        end

        # изображение
        img_dom = main_section.xpath("//img[@class='screenshots']").first

        if img_dom != nil
            img_src = img_dom.attr('src')
            anime.image_href = "#{MAIN_HREF}#{img_src}"
        end

        # описание
        description_dom = main_section.xpath("//div[@itemprop='description']/p").first

        if description_dom != nil
            anime.description = description_dom.content
        end

        anime.save
    end
end