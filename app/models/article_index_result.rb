class ArticleIndexResult < ApplicationRecord
    belongs_to :article, optional: true
end
