class UsersController <  ApplicationController

  before_action :use_db
  def index
    @users = @client.query("SELECT * FROM users")
    puts "5a5a5a5a5a5a5a5a5a5a5a5a5"

    @users.each do |row|
      # conveniently, row is a hash
      # the keys are the fields, as you'd expect
      # the values are pre-built ruby primitives mapped from their corresponding field types in MySQL

      puts row
    end
  end

  def show
    @id = params[:id]
    @user= @client.query("select * from users where id = #{@id}")
    @row = @user.first
  end

  def edit
    @id = params[:id]
    @user= @client.query("select * from users where id = #{@id}")
    @row = @user.first
  end

  def updatee

    @user= @client.query("select * from users where id = #{params[:session][:id]}")
    @row = @user.first
    puts @row
    password = params[:session][:password]
    if password.blank?
      password = @row["user_password"]
    end
    begin
      statment= @client.prepare("update users set username = ? , user_password= ? , email = ? ,address = ? where id = ? ")
      statment.execute(params[:session][:username],password,params[:session][:email],params[:session][:address],@row["id"])
      redirect_to user_path(@row["id"])
    rescue Exception => e
      flash[:danger] = e.message
      render 'edit'
    end
  end

  def new

  end

  def create
    if (params[:session][:email].blank? || params[:session][:password].blank? || params[:session][:username].blank?)
      flash[:danger] = "please fill all the required fields"
      render 'new'
    else
      begin
        statement = @client.prepare("insert into users(email,username,user_password,admin,address) values(?,?,?,?,?);")
        statement.execute(params[:session][:email],params[:session][:username],params[:session][:password],0,params[:session][:address])
        semi = '\''
        @result = @client.query("select * from users where  email = #{semi}#{params[:session][:email]}#{semi};")
        @row = @result.first
        redirect_to user_path(@row["id"])
      rescue Exception => e
        flash[:danger] = e.message
        render 'new'
      end
    end
  end




  private

  def use_db
    @client = Mysql2::Client.new(:host => "localhost", :username => "root")
    @client.query("use BookStore")
  end
end