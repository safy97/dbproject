class BooksController < ApplicationController
  before_action :validate_publisher, :validate_isbn, :validate_authors, only: [:create]
  before_action :require_admin, only: [:new,:edit,:create,:destroy,:update]
  # GET /posts
  # GET /posts.json
    def index
      puts "he6a"
      puts params
      client = Mysql2::Client.new(:host => "localhost", :username => "root")
      client.query("use BookStore")
      records = client.query("SELECT * FROM books LEFT JOIN carts ON books.id = carts.book_id;")
      @posts = []
      records.each do |row|
        @posts.append row
        puts @posts
      end
    end

  def show
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    records = client.query("SELECT * FROM books WHERE id = #{params[:id]}")
    @book = []
    records.each do |key,book|
      @book.append(key)
    end
    @book = @book[0]
  end

  # GET /posts/new
  def new
    #@post = Post.new
  end

  # GET /posts/1/edit
  def edit
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    records = client.query("SELECT * FROM books WHERE id = #{params[:id]}")
    @book = []
    records.each do |key,book|
      @book.append(key)
    end
    @book = @book[0]
  end

  # POST /posts
  # POST /posts.json
  def create
    @authors = params[:authors].split(',').uniq
    puts "ya wala bas"
    puts @authors
    @title = params[:title]
    @isbn = params[:isbn]
    @publisher = params[:publisher]
    @price = params[:price]
    @year = params[:publication_year]
    @category = params[:category][:category]
    @stock = params[:stock]
    @threshold = params[:threshold]
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    query = 'INSERT INTO books (isbn,title,publisher_id,publication_year,selling_price,category,threshold,stock) VALUES ("'+@isbn+'","'+@title+'",'+@publisher+','+@year+','+@price+',"'+@category+'",'+@threshold+','+@stock+');'
    puts query
    client.query(query)
    @authors.each do |author|
      recs = client.query("SELECT * FROM books WHERE isbn = #{@isbn}").first
      puts "testaa"
      puts recs
      client.query("INSERT INTO book_authors VALUES (#{recs["id"]},#{author})")
    end
    redirect_to books_path
  end
   def destroy
       @given_id = params[:id]
       puts @given_id
       query = 'DELETE FROM books WHERE id = '+@given_id+';'
       client = Mysql2::Client.new(:host => "localhost", :username => "root")
       client.query("use BookStore")
       client.query(query)
       flash[:danger] = "Book was successfully Deleted!"
       redirect_to books_path
   end
  def update
    @given_id = params[:id]
    @title = params[:title]
    @isbn = params[:isbn]
    @publisher = params[:publisher]
    @price = params[:price]
    @year = params[:publication_year]
    @category = params[:category][:category]
    @stock = params[:stock]
    @threshold = params[:threshold]
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    query = 'UPDATE books SET isbn = "'+@isbn+'",title = "'+@title+'",selling_price = '+@price+',publication_year = '+@year+',category = "'+@category+'",threshold = '+@threshold+',stock = '+@stock+' WHERE id = '+params[:id]+';'
    puts query
    client.query(query)
    redirect_to book_path(params[:id])
  end

  private
    def validate_publisher
      client = Mysql2::Client.new(:host => "localhost", :username => "root")
      client.query("use BookStore")
      publisher = client.query("SELECT * FROM publishers WHERE id = #{params[:publisher]}")
      if !publisher.first
        flash[:danger] = "Publisher Doesn't Exist..Please Try Again"
        redirect_to(new_book_path)
      end
    end
    def validate_isbn
      client = Mysql2::Client.new(:host => "localhost", :username => "root")
      client.query("use BookStore")
      book = client.query("SELECT * FROM books WHERE isbn = #{params[:isbn]}")
      if book.first
        flash[:danger] = "A Book with same ISBN Already Exist"
        redirect_to(new_book_path)
      end
    end

  def validate_authors
    @authors = params[:authors].split(',').uniq
    puts "VALIDATION"
    @count_not_exist = 0
    @authors.each do |author|
      client = Mysql2::Client.new(:host => "localhost", :username => "root")
      client.query("use BookStore")
      auth = client.query("SELECT * FROM authors WHERE id = #{author}")
      puts "T3ala hena"
      if !auth.first
        @count_not_exist += 1
      end
    end
    if @count_not_exist > 0
      flash[:danger] = "Author Doesn't Exist..Please Try Again"
      redirect_to(new_book_path)
    end
  end

  # # Never trust parameters from the scary internet, only allow the white list through.
  # def post_params
  #   params.require(:post).permit(:name, :comment)
  # end
end
