class PublishersController < ApplicationController
  before_action :require_admin
#  before_action :validate_publisher, :validate_isbn, :validate_authors, only: [:create]
  # GET /posts
  # GET /posts.json
  def index
    puts params
    puts "PublishOmar Bsor3a"
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    records = client.query("SELECT * FROM publishers;")
    @publishers = []
    records.each do |row|
      @publishers.append row
      puts @publishers
    end
  end

  def show
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    records = client.query("SELECT * FROM publishers WHERE id = #{params[:id]}")
    @publishers = []
    records.each do |key,book|
      @publishers.append(key)
    end
    @publisher = @publishers[0]
  end

  def edit
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    records = client.query("SELECT * FROM publishers WHERE id = #{params[:id]}")
    @publishers = []
    records.each do |key,book|
      @publishers.append(key)
    end
    @publisher = @publishers[0]
    puts @publisher
  end

  def create
    @name = params[:name]
    @address = params[:address]
    @telephone = params[:telephone]
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    query = 'INSERT INTO publishers (publisher_name,address,telephone) VALUES ("'+@name+'","'+@address+'",'+@telephone+');'
    puts query
    client.query(query)
    redirect_to publishers_path
  end

  def destroy
    @given_id = params[:id]
    puts @given_id
    query = 'DELETE FROM publishers WHERE id = '+@given_id+';'
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    client.query(query)
    flash[:danger] = "Publisher was successfully Deleted!"
    redirect_to publishers_path
  end

  def update
    @given_id = params[:id]
    puts params
    @publisher = params[:name]
    @address = params[:address]
    @telephone = params[:telephone]
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")
    query = 'UPDATE publishers SET publisher_name = "'+@publisher+'",address = "'+@address+'",telephone = '+@telephone+' WHERE id = '+params[:id]+';'
    puts query
    client.query(query)
    redirect_to publisher_path(params[:id])
  end

# # Never trust parameters from the scary internet, only allow the white list through.
# def post_params
#   params.require(:post).permit(:name, :comment)
# end
end
