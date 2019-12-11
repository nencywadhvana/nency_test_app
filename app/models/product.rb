class Product < ApplicationRecord
  belongs_to :user
  validates :name,:price, presence: true
  validates :name, uniqueness: true
end
