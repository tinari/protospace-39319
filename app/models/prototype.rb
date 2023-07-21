class Prototype < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_one_attached :image


  validates :title , :catch_copy, :concept, :image, presence: true

  def was_attached?
    self.image.attached?
  end
end
