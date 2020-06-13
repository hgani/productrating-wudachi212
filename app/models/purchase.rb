# == Schema Information
#
# Table name: purchases
#
#  id               :bigint           not null, primary key
#  delivery_address :string
#  quantity         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  product_id       :bigint
#
# Indexes
#
#  index_purchases_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class Purchase < ApplicationRecord
  belongs_to :product
  has_many :reviews

  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :delivery_address, presence: true

  validate :review_exist?

  


  # TODO: Implement this logic
  # - Return true if a review for this purchase exists in the database 
  # - Return false otherwise
  def review_exist?
    self.reviews.any?
  end

  def total_reviews
    reviews = self.reviews
    reviews.sum(rating) / reviews.ratings.count
  end
  
end
