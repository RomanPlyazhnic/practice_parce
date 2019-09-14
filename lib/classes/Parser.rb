require 'nokogiri'
require 'em-http-request'
require 'eventmachine'

class Parser
    COUNT_PROCESS = 4
    GENRES = ['Action', 'Adventure', 'BL', 'Comedy', 'Drama',
        'Ecchi', 'Fantasy', 'GL', 'Harem', 'Horror',
        'Josei', 'Magical girl', 'Mecha', 'Mystery', 'Reverse Harem',
        'Romance', 'Sci Fi', 'Seinen', 'Shoujo', 'Shoujo-ai',
        'Shounen', 'Shounen-ai', 'Slice of Life', 'Sports', 'Yaoi',
        'Yuri']

    def parse(page_downloader, href)        
        @page_downloader = page_downloader
        @count_pages = searchCountPages(href + 1.to_s)          
        @count_pages = 1        
        count_pages_for_process = @count_pages / 4

        for num_proc in (1..COUNT_PROCESS) do 
            fork do            
                threads = []  

                EM.run {
                    multi = EM::MultiRequest.new

                    for i in (0..count_pages_for_process)
                        num_page = (4 * i) + num_proc
                        puts "Process №#{num_proc}, page №#{num_page}"
                        http = EM::HttpRequest.new(href + num_page.to_s).get

                        http.callback {
                            threads << Thread.new do
                                searchAnimes(http.response, num_proc, num_page)
                            end
                        }

                        http.errback {p 'Error loading page'; EM.stop}
                        multi.add i, http
                    end

                    multi.callback {
                        p multi.responses[:callback].size
                        p multi.responses[:errback].size
                        EM.stop
                    }
                }   

                threads.each do |t|
                    t.join
                end                            
            end
        end

        Process.waitall
        puts "КОНЕЦ!!!!!"
    end

    def searchCountPages(href)
        begin
            page = @page_downloader.download(href)
       
            if page.nil?
                return 0
            else                
                el_count_pages = page.xpath("//div[@class='pagination aligncenter']//li[last() - 1]/a").first
                count_pages = el_count_pages.content.to_i
                return count_pages
            end
        rescue
            puts 'Ошибка в нахождении количества страниц'
        end
    end

    def searchAnimes(page, process, num_page)
        Thread.current.exit if num_page > @count_pages 
        
        begin
            anime_links = Nokogiri::HTML(page).xpath("//ul[@class='cardDeck cardGrid']//li//a")[0..2]
        rescue
            puts 'Ошибка в получении аниме'
        end

        anime_links.each do |anime_link|
            begin 
                href = "https://www.anime-planet.com#{anime_link.attr('href')}"
                parseAnime(href)
            rescue
                puts 'Ошибка в аниме'
            end
        end
    end

    def parseAnime(href)
        anime_page = @page_downloader.download(href)
        top_section = anime_page.xpath("//section[@class='pure-g entryBar']")
        main_section = anime_page.xpath("//div[@class='pure-g entrySynopsis']")

        # название
        name = anime_page.xpath("//h1[@itemprop='name']").first.content
        puts name

        # тип
        kind = top_section.xpath("//span[@class='type']").first.content
        
        # студия
        studio = top_section.xpath("//div[@class='pure-1 md-1-5'][position()=1]").first.content.strip
        
        # год
        year = top_section.xpath("//div[@class='pure-1 md-1-5']/span[@class='iconYear']").first.content.strip
        
        # ранг
        reg_rank = /\d+/m
        rank = top_section.xpath("//div[@class='pure-1 md-1-5'][last()]").first.content.scan(reg_rank).first
        
        # жанры
        basic_genres = Array.new
        genres = main_section.xpath("//li[@itemprop='genre']/a")

        genres.each do |genre_el|
            genre = genre_el.content.strip

            basic_genres.push(genre) if GENRES.include?(genre)
        end

        # изображение
        src = main_section.xpath("//img[@class='screenshots']").first.attr('src')
        image_href = "https://www.anime-planet.com#{src}"

        # описание
        description = main_section.xpath("//div[@itemprop='description']/p").first.content

        # запись в базу данных
        genres_hash = Hash.new

        basic_genres.each do |genre|
            genres_hash[genre.gsub(/ /, '_').to_sym] = true
        end

        db_genres = Genre.create(genres_hash)
        anime = Anime.create(
            name: name,
            kind: kind,
            studio: studio,
            year: year,
            rank: rank,
            image_href: image_href,
            description: description,
            genre: db_genres
        )
    end
end