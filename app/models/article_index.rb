class ArticleIndex < ApplicationRecord
    belongs_to :article, optional: true
    
    
    def indexApproval
        article_id = self.article_id
        user_id = self.applicant_id
        self.delete
        article = Article.find_by(id:article_id)
        article.index = true
        article.save
        
        aIR = ArticleIndexResult.new(article_id:article_id,result:true,reason:"")
        aIR.save
        
        score = UserScore.find_by(user_detail_id:user_id)
        score.score += 10
        
        return score.save
    end
    def indexNonApproval
        article_id = self.article_id
        self.delete
        aIR = ArticleIndexResult.new(article_id:article_id,result:false,reason:"")
        
        return aIR.save
    end
end
