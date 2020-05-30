namespace :get_lyrics do
  desc "歌詞取得"
    task get_lyrics: :environment do
        require 'nokogiri'
        require 'open-uri'
        require 'csv'
        
        countop=0

        for i in 0..278105 do
            o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
            pas =(0...20).map { o[rand(o.length)] }.join
            url = 'https://www.uta-net.com/song/'+i.to_s

            charset = 'utf-8'
            begin
                html = open(url,'User-Agent' => 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)') { |f| f.read }
                rescue OpenURI::HTTPError => e
                sleep (0.5)
                countop+=1
                p countop
                if countop>50 then
                    break
                end
                next
            end
            
            countop=0
            doc = Nokogiri::HTML.parse(html, nil, charset)
            
            #歌詞のスクレイピング
            if doc.xpath('//div[@id="kashi_area"]') then a = doc.xpath('//div[@id="kashi_area"]').inner_html end
            if doc.xpath('//span[@itemprop="byArtist name"]') then b = doc.xpath('//span[@itemprop="byArtist name"]').text end
            if doc.xpath('//h4[@itemprop="lyricist"]') then c = doc.xpath('//h4[@itemprop="lyricist"]').text end
            if doc.xpath('//h4[@itemprop="composer"]') then d = doc.xpath('//h4[@itemprop="composer"]').text end
            if doc.xpath('//div[@id="view_amazon"]/a/@href')[0] then e = doc.xpath('//div[@id="view_amazon"]/a/@href')[0].text[/ASIN=(.*)/,1] end
            if doc.xpath('//div[@id="view_amazon"]/a[last()]/@href') then f = doc.xpath('//div[@id="view_amazon"]/a[last()]/@href').text[/id(.*)\?i/,1] end
            if doc.xpath('//h2') then g = doc.xpath('//h2').text end
            if doc.xpath('//div[@id="view_amazon"]/a/img/@src')[0] then h = doc.xpath('//div[@id="view_amazon"]/a/img/@src')[0].text end
            id =pas

            p i
            p 'アーティスト：' + b + ' 作詞:' + c + ' 作曲:' +d
            p id
            
            p '##############################################'
        
            if Lyric.exists?(:title => g,:artist => b)then
                p "Lyric is allready exsits."
            else
                filePath = "app/assets/images/s_jac/" + pas +'.png'

                # create folder if not exist
                FileUtils.mkdir_p("app/assets/images/s_jac/") unless FileTest.exist?("app/assets/images/s_jac/")
            # write image adata
        if h != "/reverse/user/phplib/view/itunes_button.png" && h !="/reverse/user/phplib/view/amazon_buy.png" then
    begin
            open(filePath, 'wb') do |output|
                open(h) do |data|
                    output.write(data.read)
                end
            end
    rescue
    next
    end
        end
        book = Lyric.new(:key => id,:title => g,:artist =>b,:lyricist =>c,:composer => d,:lyrics => a,:amazonUrl =>e,:iTunesUrl =>f)
        book.save
        p "seved"
    end
    sleep(1.5)

            end

        end
end
