class Category < ApplicationRecord
    has_many :post_category_relations
    has_many :articles, through: :post_category_relations
end
