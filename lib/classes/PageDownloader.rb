require 'curb'

class PageDownloader
    def download(href)
        html_doc = Curl.get(href).body_str

        if html_doc.empty?
            return nil
        end
        
        return Nokogiri::HTML(html_doc)
    end
end