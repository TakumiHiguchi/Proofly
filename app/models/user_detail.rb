class UserDetail < ApplicationRecord
    has_many :articles
    has_many :scores
    belongs_to :user, optional: true
    
    
    #s3イメージアップロード
    mount_uploader :thum1, ImageUploader
    mount_uploader :thum2, ImageUploader
    #フォローフォロワー
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverse_of_relationships, source: :user_detail
    
    validates :user_key, length: { in: 1..30 }, uniqueness: true
    validates :name, length: { in: 1..30 }
    validates :bio, length: { in: 0..150 }
    
    def follow(other_user)
      unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end

    def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end

    def following?(other_user)
      self.followings.include?(other_user)
    end
    
    def set_user_settings()
        settings = userd=[ self.name, self.user_key, self.id, self.thum1, self.thum2, self.status]
        return settings
    end
    
    def set_follow_article()
        followUser = Relationship.where(user_detail_id: self.id)
        recommended = []
        if followUser then
            followUser.each do |p|
                ans = UserDetail.joins(articles: :article_sales).select("user_details.*, articles.*,article_sales.*").where('user_details.id= ? ',p.follow_id).last
                recommended.push(ans) unless ans.nil?
            end
            recommended.shuffle!
            recommended.slice!(0..8) if followUser.length > 8
        end
        return recommended
    end
    def self.search(search,type)
        return self.all unless search
        
        
        keywords = search.split(/[[:blank:]]+/)
        articles = self
        
        keywords.each do |keyword|
            articles = articles.where("UPPER(title) LIKE ?", "%#{keyword.upcase}%") #分割されたキーワードでの検索
        end
        
        return articles
    end
    def self.userSort(ukey)
        return self.all unless ukey
        self.where(user_key:ukey)
    end
end

