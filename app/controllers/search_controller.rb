class SearchController < ApplicationController
  def create
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore");
    @test = 0
    query = "SELECT * FROM books"
    if params[:search] != nil
      puts params
      if params[:searchby][:searchby] == "ISBN"
        query += ' WHERE isbn = "'+params[:search]+'" '
      else
        query += ' WHERE title = "'+params[:search]+'" '
      end
      if params[:publisher] != ""
        query += " publishers ON books.publisher_id = publisher.id "
      end
      if params[:author] != ""
        query += " JOIN book_authors ON books.id = book_authors.book_id JOIN authors ON authors.id = book_authors.author_id "
      end
      if params[:category][:category] != "All Categories"
        query += ' category = "'+params[:category][:category]+'"'
        @test = 1
      end
      if params[:author] != ""
        if @test == 1
          query += ' AND '
        end
        query += ' author_name = "'+params[:author]+'"'
        @test = 1
      end
      if params[:publisher] != ""
        if @test == 1
          query += ' AND '
        end
        query += ' publisher_name = "'+params[:publisher]+'"'
      end
    end
    puts query
    puts "yala b2a w aywa b2a"
    records = client.query(query)
    @posts = []
    records.each do |row|
      @posts.append row
    end
    redirect_to search_path(passed_parameters: @posts)
  end

  def show
    @posts = params[:passed_parameters]
  end
end
