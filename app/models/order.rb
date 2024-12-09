class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  validates :address, presence: true
  validates :order_date, presence: true
end
