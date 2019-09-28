module QueryHelper
    def query_order(order)
        if request.original_fullpath.include?('?')
            url = request.original_fullpath + '&'
        else
            url = request.original_fullpath + '/?'
        end

        url.gsub!(/&?order=\w+/, '')
        url.gsub!('//', '/')

        url = url + "order=" + order
    end
end