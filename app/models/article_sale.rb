class ArticleSale < ApplicationRecord
    belongs_to :article, optional: true
    
    validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 ,less_than: 1000000}
    validates :afe, numericality: { only_integer: true, greater_than_or_equal_to: 0 ,less_than: 100}
    
    def saveSales(sales_type, post_id, p_length, price, afe)
        if sales_type == 0 then
            sa = ArticleSale.create(article_id: post_id,sales_type: 0,price: 0,afe: 0)
        elsif sales_type == 1 then
            if p_length > 0 then
                sa = ArticleSale.create(article_id: post_id,sales_type: 1,price: price,afe: afe)
            else
                sa = ArticleSale.create(article_id: post_id,sales_type: 0,price: 0,afe: 0)
            end
        end
        
        if sa.save then
            return true
        else
            sa = ArticleSale.create(article_id: post_id,sales_type: 0,price: 0,afe: 0)
            return sa.save
        end
        
    end
    def updateSales(sales_type, post_id, p_length, price, afe)
        if sales_type == 0 then
            sa = self.update(article_id: post_id,sales_type: 0,price: 0,afe: 0)
        elsif sales_type == 1 then
            if p_length > 0 then
                sa = self.update(article_id: post_id,sales_type: 1,price: price,afe: afe)
            else
                sa = self.update(article_id: post_id,sales_type: 0,price: 0,afe: 0)
            end
        end
        
        if sa then
            return true
        else
            sa = self.update(article_id: post_id,sales_type: 0,price: 0,afe: 0)
            return sa
        end
        
    end
end
