class ApplicationController < ActionController::Base



  def require_user
    if !session[:id]
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to books_path
    end
  end

  def require_admin
    if !admin?
      flash[:danger] = "You must be admin"
      redirect_to books_path
    end
  end

  def admin?
    if session[:id]
      client = Mysql2::Client.new(:host => "localhost", :username => "root")
      client.query("use BookStore")
      getUserQuery = "SELECT * FROM users WHERE id = #{session[:id]};"
      getUserRecord = client.query(getUserQuery).first
      puts "Admin"

      if getUserRecord["admin"] == 0
        return false
      else
        return true
      end
    end
  end
end
