class Api::V1::ReviewsController < ApplicationController

	before_action :load_book, only: [:index]
	before_action :load_review, only: [:show, :update, :destroy]
	before_action :authenticate_with_token!, only: [:create, :update, :destroy]

	def index
		@reviews = @book.reviews
		reviews_serializer = parse_json @reviews
		json_response "index reviews successfully", true, {reviews: reviews_serializer}, :ok
	end

	def show
		review_serializer = parse_json @reviews
		json_response "show review successfully", true, {review: review_serializer}, :ok
	end

	def create
		review = Review.new review_params
		review.user = current_user
		review.book_id = params[:book_id]
		if review.save
			review_serializer = parse_json review
			json_response "create reviews successfully", true, {review: review_serializer}, :ok
		else
			json_response "created review fail", false, {}, :unprocessable_entity
		end
	end

	def update
		if correct_user @review.user
			if @review.update review_params
				review_serializer = parse_json @review
				json_response "update reviews successfully", true, {review: review_serializer}, :ok
			else
				json_response "update review fail", false, {}, :unprocessable_entity
			end
		else
			json_response "you don't have permissions", false, {}, :unauthorized
		end
	end

	def destroy
		if correct_user @review.user
			if @review.destroy
				json_response "review deleted successfully", true, {}, :ok
			else
				json_response "deleted review fail", false, {}, :unprocessable_entity
			end
			json_response "you don't have permissions", false, {}, :unauthorized
		end
	end

   private

   def load_book
   	@book = Book.find_by id: params[:book_id]
   		unless @book.present?
			json_response "can not get book", false, {}, not_found
		end
   end

   def load_review
   	@review = Review.find_by id: params[:id]
	   	unless @review.present?
	   		json_response "can not get review", false, {}, not_found
	   	end
    end

    def review_params
    	params.require(:review).permit(:title, :content_rating, :recommand_rating)
    end
end