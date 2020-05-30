class Relationship < ApplicationRecord
    belongs_to :user_detail
    belongs_to :follow, class_name: 'UserDetail'

    validates :user_detail_id, presence: true
    validates :follow_id, presence: true
end
