class Tag < ApplicationRecord
    has_many :post_tag_relations
    has_many :articles, through: :post_tag_relations
    
    validates :name, length: { in: 1..128 }
    
    def saveTag(current_user_id, tag, post_id, tag_bl)
        if tag.to_s.length > 0 && tag_bl then
            if Tag.find_by(name: tag).nil? then
                qw = Tag.create(name: tag,tag_key: Digest::SHA3.hexdigest(tag, 256)[0,30],tag_type: 1,created_user_id: current_user_id)
                return false unless qw.save
            end
            tagId =Tag.find_by(name: tag).id
            cd = PostTagRelation.create(article_id: post_id,tag_id: tagId)
            if cd.save then
                return true
            else
                return false
            end
        else
            return false
        end
    end
    
    def updateTag(current_user_id, tag, post_id)
        ztags = PostTagRelation.where(article_id: post_id)
        zc = ztags.count
        for i in 0..2 do
            if tag[i].to_s.length > 0 then
                if Tag.find_by(name: tag[i]).nil? then
                    qw = Tag.create(name: tag[i],tag_key: Digest::SHA3.hexdigest(tag[i], 256)[0,30],tag_type: 1,created_user_id: current_user_id)
                    qw.save
                end

                tagId =Tag.find_by(name: tag[i]).id

                if (i+1) <= zc then
                    k = PostTagRelation.find_by(id: ztags[i].id)
                    k.tag_id = tagId
                    k.save
                else
                    cd = PostTagRelation.create(article_id: post_id,tag_id: tagId)
                    cd.save
                end
            end
        end
        
        
    end
end
