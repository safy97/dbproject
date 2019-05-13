class CartController < ApplicationController
  before_action :require_user
  def create
    respond_to do |format|
      format.js
    end
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    puts params
    @user_id = session[:id]
    @book_id = params["book_id"]

    queryStock = "SELECT * FROM books WHERE id = #{@book_id};"
    strecord = client.query(queryStock)
    @num_stock = 0
    strecord.each do |rec|
      puts rec
      @num_stock = rec["stock"]
    end
    update_stock = "UPDATE books SET stock = #{@num_stock-1} WHERE id = #{@book_id};"
    client.query(update_stock)

    query = "SELECT * FROM carts WHERE user_id = #{@user_id} AND book_id = #{@book_id};"
    puts "omar:: "+query
    records = client.query(query)
    @price = 0
    if !records.first
      insert_query = "INSERT INTO carts VALUES (#{@user_id},#{@book_id},1);"
      client.query(insert_query)
    else
      @num_in_cart = 0
      records.each do |rec|
        puts "heouajsldk"
        puts rec
        @num_in_cart = rec["quantityruby"]
        @price = rec["selling_price"]
      end
      puts @num_in_cart
      update_query = "UPDATE carts SET quantityruby = #{@num_in_cart+1} WHERE user_id = #{@user_id} AND book_id = #{@book_id};"
      puts " update: " + update_query
      client.query(update_query)
    end
  end

  def show
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    puts params
    @user_id = session[:id]
    @book_id = params["id"]
    query = "SELECT * FROM books JOIN carts ON books.id = carts.book_id WHERE carts.user_id = #{@user_id};"
    records = client.query(query)
    @posts = []
    records.each do |row|
      @posts.append row
      puts @posts
    end
  end

  def destroy
    puts params
    puts "5 mwah"
    respond_to do |format|
      format.js
    end

    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    @user_id = session[:id]
    @book_id = params["book_id"]
    queryStock = "SELECT * FROM books WHERE id = #{@book_id};"
    strecord = client.query(queryStock)
    @num_stock = 0
    strecord.each do |rec|
      puts rec
      @num_stock = rec["stock"]
    end
    update_stock = "UPDATE books SET stock = #{@num_stock+1} WHERE id = #{@book_id};"
    client.query(update_stock)



    puts "OMAR DELETE"
    puts params
    puts params

    query = "SELECT * FROM carts WHERE user_id = #{@user_id} AND book_id = #{@book_id};"
    records = client.query(query)
    @posts = []
    records.each do |row|
      @posts.append row
      puts @posts
    end

    if @posts[0]["quantityruby"] == -1
      delete_query = "DELETE FROM carts WHERE carts.user_id = #{@user_id} AND carts.book_id = #{@book_id};"
      client.query(delete_query)
      redirect_to "/cart/#{@user_id}"
    else
      update_query = "UPDATE carts SET quantityruby = #{@posts[0]["quantityruby"]-1} WHERE carts.user_id = #{@user_id} AND carts.book_id = #{@book_id};"
      client.query(update_query)
    end

  end


end
