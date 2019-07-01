class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :content_rating, :recommand_rating, :average_rating
  belongs_to :book
  belongs_to :user
end
