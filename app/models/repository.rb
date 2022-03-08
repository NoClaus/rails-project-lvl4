class Repository < ApplicationRecord
  extend Enumerize
  
  belongs_to :user
  
  validates :github_id, presence: true
  
  enumerize :language, in: AVAILABLE_LANGUAGES
end
