class BooksController < ApplicationController
	before_action :authenticate_user!
	before_action :correct_book, only: [:edit]

  def show
		@book = Book.find(params[:id])
		@books = Book.all
		@book_new = Book.new
		@book_comment = BookComment.new
  end

  def index
		@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
		@book = Book.new
		@user = current_user
  end

  def create
		@books = Book.all
		@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
		@book.user_id = current_user.id
  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to @book, notice: "successfully created book!"#保存された場合の移動先を指定。
		else
			@user = current_user
  		render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render "edit"
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body, :user_id)
	end
	
	def correct_book
		book = Book.find(params[:id])
		if book.user != current_user
			redirect_to books_path
		end
	end
end
