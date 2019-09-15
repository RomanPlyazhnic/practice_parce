require 'nokogiri'
require 'em-http-request'
require 'eventmachine'

class Parser
    MAIN_HREF = 'https://www.anime-planet.com'
    PAGE_DOWNLOADER = PageDownloader.new
    COUNT_PROCESS = 4
    GENRES = ['Action', 'Adventure', 'BL', 'Comedy', 'Drama',
        'Ecchi', 'Fantasy', 'GL', 'Harem', 'Horror',
        'Josei', 'Magical girl', 'Mecha', 'Mystery', 'Reverse Harem',
        'Romance', 'Sci Fi', 'Seinen', 'Shoujo', 'Shoujo-ai',
        'Shounen', 'Shounen-ai', 'Slice of Life', 'Sports', 'Yaoi',
        'Yuri']

    def parse()        
        # очистка таблиц
        Genre.delete_all
        Anime.delete_all
        # -----
        @count_pages = searchCountPages("#{MAIN_HREF}/anime/all?page=1")          
        @count_pages = 5
        count_pages_for_process = @count_pages / 4
        
        # поиск страниц
        for num_proc in (1..COUNT_PROCESS) do 
            fork do            
                threads = []  

                for i in (0..count_pages_for_process)
                    num_page = (4 * i) + num_proc
                    href = "#{MAIN_HREF}/anime/all?page=#{num_page}"

                    threads << Thread.new(href, num_page) do |h, n|
                        searchAnimes(h, n)
                    end
                end

                threads.each do |t|
                    t.join
                end                            
            end
        end

        Process.waitall
        puts "КОНЕЦ!!!!!"
    end

    private

    def searchCountPages(href)
        begin
            page = PAGE_DOWNLOADER.download(href)
       
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

    def searchAnimes(href, num_page)
        Thread.current.exit if num_page > @count_pages

        page = PAGE_DOWNLOADER.download(href)

        begin
            anime_links = page.xpath("//ul[@class='cardDeck cardGrid']//li//a")
        rescue
            puts 'Ошибка в получении аниме'
        end

        anime_links.each do |anime_link|
            begin 
                href = "#{MAIN_HREF}#{anime_link.attr('href')}"
                parseAnime(href)
            rescue
                puts 'Ошибка в аниме'
            end
        end
    end

    def parseAnime(href)
        anime_page = PAGE_DOWNLOADER.download(href)
        top_section = anime_page.xpath("//section[@class='pure-g entryBar']")
        main_section = anime_page.xpath("//div[@class='pure-g entrySynopsis']")

        # название
        name = anime_page.xpath("//h1[@itemprop='name']").first.content

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
        image_href = "#{MAIN_HREF}#{src}"

        # описание
        description = main_section.xpath("//div[@itemprop='description']/p").first.content

        # запись в базу данных
        anime = Anime.create(
            name: name,
            kind: kind,
            studio: studio,
            year: year,
            rank: rank,
            image_href: image_href,
            description: description
        )

        basic_genres.each do |genre|
            a = Genre.create(genre: genre)
            anime.genre << a
        end
    end
end