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
    session[:id] = nil
    redirect_to books_path
  end

  private

  def use_db
    @client = Mysql2::Client.new(:host => "localhost", :username => "root")
    @client.query("use BookStore")
  end
end