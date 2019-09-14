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
            anime_links = Nokogiri::HTML(page).xpath("//ul[@class='cardDeck cardGrid']//li//a")
        rescue
            puts 'Ошибка в получении аниме'
        end

        anime_links.each do |anime_link|
            begin 
                href = "https://www.anime-planet.com#{anime_link.attr('href')}"
                parseAnime(href)
            rescue
                puts 'Ошибка в ссылке на аниме'
            end
        end
    end

    def parseAnime(href)
        anime_page = @page_downloader.download(href)

        # жанры
        basic_genres = Array.new
        genres = anime_page.xpath("//li[@itemprop='genre']/a")

        genres.each do |genre_el|
            genre = genre_el.content.strip

            basic_genres.push(genre) if GENRES.include?(genre)
        end

        
    end
end