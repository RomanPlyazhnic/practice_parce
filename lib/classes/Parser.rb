require 'nokogiri'
require 'em-http-request'
require 'eventmachine'

class Parser
    def parse(page_downloader, href)
        count_process = 4
        @page_downloader = page_downloader
        #searchPages(href, number_page)

        for num_proc in (1..count_process) do 
            fork do            
                threads = []  
                EM.run {
                    multi = EM::MultiRequest.new

                    for i in (0..1)
                        num_page = (4 * i) + num_proc
                        puts "Process №#{num_proc}, page №#{num_page}"
                        http = EM::HttpRequest.new(href + num_page.to_s).get #:query => {'XXX'}
                        http.callback {
                            threads << Thread.new do
                                searchAnimes(http.response, num_proc, num_page)
                            end
                            #puts "Process №#{num_proc}, page №#{num_page}"
                            #puts http.response
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

    def searchPages(href, number_page)        
        result_href = href + number_page.to_s

        puts "страница № #{number_page}"
        page = @page_downloader.download(result_href)
       
        if page.nil?
            return
        else
            #
            # ЗДЕСЬ БУДЕМ ПАРСИТЬ СТРАНИЦУ
            #
            #number_page = number_page + 1
            #searchPages(href, number_page)
        end  
    end

    def searchAnimes(page, process, num_page)
        begin
            animes = Nokogiri::HTML(page).xpath("//div[@class='crop']//img")
        rescue
            puts 'Ошибка в получении аниме'
        end

        animes.each do |anime|
            begin 
                anime_name = anime.attr('alt')
                puts "#{anime_name}, process #{process}, page #{num_page}"
            rescue
                puts 'Ошибка в аниме'
            end
        end
    end
end