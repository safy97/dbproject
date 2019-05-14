class PaymentController < ApplicationController
  before_action :require_user
  skip_before_action :verify_authenticity_token
  def show
    @user_id = params[:user_id]
  end
  def create
    getCart = "SELECT * FROM carts WHERE user_id = #{params["user_id"]};"
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    puts "PAYMENT Omar"
    puts params
    client.query("use BookStore")
    cartRecords = client.query(getCart)
    cartRecords.each do |rec|
      getBook = "SELECT * FROM books WHERE id = #{rec["book_id"]};"
      bookRecord = client.query(getBook).first
      insertTransaction = "INSERT INTO transactions (user_id,book_id,quantity,total_price) VALUES (#{rec["user_id"]},#{rec["book_id"]},#{rec["quantityruby"]},#{bookRecord["selling_price"]});"
      client.query(insertTransaction)
    end
    clearCart = "DELETE FROM carts WHERE user_id = #{params["user_id"]};"
    client.query(clearCart)
    flash[:success] = "Congratulations!"
    redirect_to books_path
  end
end