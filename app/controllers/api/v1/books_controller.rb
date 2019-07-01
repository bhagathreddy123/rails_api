class Api::V1::BooksController < ApplicationController

  before_action :load_book, only: :show

	def index
		@books = Book.all
		books_serializer = parse_json @books
		json_response "index books successfully", true, {books: books_serializer}, :ok
	end

	def show
		book_serializer = parse_json @book
		json_response "show book successfully", true, {book: book_serializer}, :ok
	end

	private

	def load_book
		@book = Book.find_by id: params[:id]
		unless @book.present?
			json_response "can not get book", false, {}, not_found
		end
	end

end