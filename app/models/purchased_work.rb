class PurchasedWork < ApplicationRecord
    belongs_to :article, optional: true
end
