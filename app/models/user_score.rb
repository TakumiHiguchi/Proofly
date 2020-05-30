class UserScore < ApplicationRecord
    belongs_to :user_detail, optional: true
end
