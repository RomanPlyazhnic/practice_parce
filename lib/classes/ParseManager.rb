class ParseManager
    def initialize(page_downloader, parser, href)
        @page_downloader = page_downloader
        @parser = parser
        @href = href
    end

    def execute
        products = @parser.parse(@page_downloader, @href)
    end
end