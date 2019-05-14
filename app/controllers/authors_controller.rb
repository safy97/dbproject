class AuthorsController < ApplicationController
  before_action :require_admin
#  before_action :set_post, only: [:show, :edit, :update, :destroy]
#  before_action :validate_publisher, :validate_isbn, :validate_authors, only: [:create]
# GET /posts
# GET /posts.json
  def index
    puts params
    puts "Author Bsor3a"
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    records = client.query("SELECT * FROM authors;")
    @authors = []
    records.each do |row|
      @authors.append row
      puts @authors
    end
  end

  def show
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    records = client.query("SELECT * FROM authors WHERE id = #{params[:id]}")
    @authors = []
    records.each do |key,book|
      @authors.append(key)
    end
    @author = @authors[0]
  end

  def edit
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    records = client.query("SELECT * FROM authors WHERE id = #{params[:id]}")
    @authors = []
    records.each do |key,book|
      @authors.append(key)
    end
    @author = @authors[0]
    puts @author
  end

  def create
    @name = params[:name]
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    query = 'INSERT INTO authors (author_name) VALUES ("'+@name+'");'
    puts query
    client.query(query)
    redirect_to authors_path
  end

  def destroy
    @given_id = params[:id]
    puts @given_id
    query = 'DELETE FROM authors WHERE id = '+@given_id+';'
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    client.query(query)
    flash[:danger] = "Author was successfully Deleted!"
    redirect_to authors_path
  end

  def update
    @given_id = params[:id]
    puts params
    @author = params[:name]
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    query = 'UPDATE authors SET author_name = "'+@author+'" WHERE id = '+params[:id]+';'
    puts query
    client.query(query)
    redirect_to author_path(params[:id])
  end

# # Never trust parameters from the scary internet, only allow the white list through.
# def post_params
#   params.require(:post).permit(:name, :comment)
# end
end
