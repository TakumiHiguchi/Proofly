class Article < ApplicationRecord
    belongs_to :user_detail, optional: true
    has_many :article_indices
    has_many :article_index_results
    has_many :post_category_relations
    has_many :categories, through: :post_category_relations
    
    has_many :post_tag_relations
    has_many :tags, through: :post_tag_relations
    has_many :article_sales
    has_many :purchased_works
    
    mount_uploader :thum, ImageUploader
    
    validates :title, length: { in: 1..100 }
    validates :description, length: { in: 1..150 }
    
    def create_paidArticle_form(isPaid,user,purchased)
        if isPaid.sales_type == 0 then
            return self.content
        else
            if purchased.nil?
                cn = "<div class='paid'>この続きを見るには</div><p class='paid-ens'>この続き: #{ApplicationController.helpers.strip_tags(self.paidcontent).length}文字</p><div class='paid-con'><div class='paidinner'><div class='pacard'><div class='p-left'><img src='https://hiiragi000.xsrv.jp/images/techlife/postl/S__Bitwith__2.jpeg' alt='Bitwith'/></div><div class='p-right'><p class='tcdw'>#{self.title}</p><p class='fouw'>#{user.name}</p><p>#{isPaid.price.to_s(:delimited)}円</p></div></div><a class='ands linkBox' href='/nuser/#{user.user_key}/article/#{self.key}/buy'>購入する</a></div></div>"
                return self.content.sub(/<div class="paidcon"><\/div>/, cn)
            else
                return self.content.sub(/<div class="paidcon"><\/div>/, self.paidcontent)
            end
        end
    end
    
    def save_other(datas, content, user_id, sales_type, commit)
        o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
        a =(0...20).map { o[rand(o.length)] }.join
          
        paidcontent = content.match(/<div class=\"paid\">ここから有料部分<\/div>.*?<div class=\"paid-end\">ここまで有料部分<\/div>/).to_s.gsub(/<div class="paid">ここから有料部分<\/div>/, '').gsub(/<div class="paid-end">ここまで有料部分<\/div>/, '')
        nomal = content.to_s.sub(/<div class=\"paid\">ここから有料部分<\/div>.*?<div class=\"paid-end\">ここまで有料部分<\/div>/,'<div class="paidcon"></div>').to_s.gsub(/<div class="paid">ここから有料部分<\/div>/, '').gsub(/<div class="paid-end">ここまで有料部分<\/div>/, '')
        
        datas.user_detail_id = user_id
        datas.key = a
        datas.paidcontent = paidcontent
        
        if sales_type == 0 then
            datas.content = content.to_s.gsub(/<div class=\"paid\">ここから有料部分<\/div>.*?<div class=\"paid-end\">ここまで有料部分<\/div>/, '')
        else
            datas.content = nomal
        end
        
        if commit == "記事を公開" then
            datas.article_status = "publish"
        else
            datas.article_status = "private"
        end
        
        return datas
    end
    
    
end
