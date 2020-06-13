# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  name       :string
#  price      :decimal(, )
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
  has_many :purchases
  has_many :reviews, through: :purchases
  
  validates :name, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  
  validate :quantity_within_limit

  # mendapatkan total rating dari reviews
  def total_rating
    self.purchases.joins(:reviews).pluck('COALESCE(sum(reviews.rating)/count(reviews.id),0) as total_rating')
  end

  def quantity_within_limit
    return unless quantity

    if quantity < 0
      errors.add(:quantity, 'too few')
    end
  end

end
