class PostTagRelation < ApplicationRecord
    belongs_to :article
    belongs_to :tag
end
