class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_admin, only: [:confirm,:index]
  def index
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    getOrderQuery = "SELECT orders.id,orders.book_id,orders.quantity,books.title,books.isbn,books.selling_price,books.category FROM orders LEFT JOIN books ON books.id = orders.book_id;"
    @orders = []
    records = client.query(getOrderQuery)
    records.each do |row|
      @orders.append row
      puts @orders
    end
  end

  def create
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    getOrderQuery = "SELECT * FROM orders WHERE book_id = #{params["book_id"]}"
    alreadyOrdered = client.query(getOrderQuery).first
    if alreadyOrdered
      updateQuery = "UPDATE orders SET quantity = #{alreadyOrdered["quantity"].to_i + params["quantity"].to_i} WHERE book_id = #{params["book_id"]};"
      puts updateQuery
      client.query(updateQuery)
    else
      insertQuery = "INSERT INTO orders (book_id,quantity) VALUES (#{params["book_id"]},#{params["quantity"]});"
      puts insertQuery
      client.query(insertQuery)
    end
    redirect_to '/orders/'
  end

  def confirm
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    deleteQuery = "DELETE FROM orders WHERE id = #{params["id"]};"
    puts deleteQuery
    client.query(deleteQuery)
    # getOrder = "SELECT * FROM orders WHERE id = #{params["id"]}"
    # puts getOrder
    # record = client.query(getOrder).first
    # getBook = "SELECT * FROM books WHERE id = #{params["book_id"]};"
    # incBook = client.query(getBook).first
    # updateQuery = "UPDATE books SET stock = #{record["quantity"].to_i + incBook["stock"].to_i} WHERE id = #{params["book_id"]};"
    # client.query("DELETE FROM orders WHERE id = #{params["id"]}")
    # puts updateQuery
    # client.query(updateQuery)
    redirect_to '/orders/'
  end

  def destroy
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    deleteQuery = "DELETE FROM orders WHERE id = #{params["id"]};"
    puts deleteQuery
    client.query(deleteQuery)
    redirect_to '/orders/'
  end

end