class ArticleRecommend
    def tagRecommend( _tags, _count)
        tagRdata=[]
        _tags.each do |pass|
            instantTR = [pass.name,pass.tag_key,pass.id]
            insArt = UserDetail.joins(articles: :tags).select("user_details.*,articles.*,tags.id AS tagid").where('tags.name = ? ',pass.name).order("articles.created_at DESC").limit(_count)
            instantTR.push(insArt)
            tagRdata.push(instantTR)
        end
        firstTagCount = PostTagRelation.where(tag_id:tagRdata[0][2].to_i).count if tagRdata.length > 0
        return tagRdata,firstTagCount
    end
end
