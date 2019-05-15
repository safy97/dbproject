module ApplicationHelper
  def admin?
    if session[:id]
      client = Mysql2::Client.new(:host => "localhost", :username => "root")
      client.query("use BookStore")
      getUserQuery = "SELECT * FROM users WHERE id = #{session[:id]};"
      getUserRecord = client.query(getUserQuery).first
      puts "Admin"
      if getUserRecord == nil
        return false
      end

      if getUserRecord["admin"] == 0
        return false
      else
        return true
      end
    end
  end

  def user?
    puts sessions[:id]
    return session[:id]
  end

end
