class SessionsController < ApplicationController
  before_action :use_db


  def login

  end

  def create
    username = params[:session][:username]
    statment = @client.prepare("select * from users where username = ?")
    @result = statment.execute(username)
    @row = @result.first
    if @row.nil?
        flash[:danger] = "username not found --to be edited flash"
        render 'login'
    else
      password = @row["user_password"]
      if password != params[:session][:password]
        flash[:danger] = "password is wrong"
        render 'login'
      else
        flash[:success]="you have logged in"
        session[:id] = @row["id"].to_i
        redirect_to user_path(@row["id"].to_i)
      end
    end
  end

  def logout
    @user_id = session[:id]
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    queryStock = "SELECT * FROM carts WHERE user_id = #{@user_id};"
    rec11 = client.query(queryStock)
    rec11.each do |rec1|
      puts rec1
      getBook = "SELECT * FROM books WHERE id = #{rec1["book_id"]};"
      puts getBook
      strecord = client.query(getBook)
      @num_stock = 0
      strecord.each do |rec|
        puts rec
        @num_stock = rec["stock"]
      end
      update_stock = "UPDATE books SET stock = #{@num_stock+rec1["quantityruby"]} WHERE id = #{rec1["book_id"]};"
      puts update_stock
      client.query(update_stock)
    end





    query = "DELETE FROM carts WHERE user_id = #{@user_id};"
    client.query(query)
    session[:id] = nil
    redirect_to books_path
  end

  private

  def use_db
    @client = Mysql2::Client.new(:host => "localhost", :username => "root")
    @client.query("use BookStore")
  end
end