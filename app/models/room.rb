class Room < ApplicationRecord
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
