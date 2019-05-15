class ReportsController < ApplicationController
  before_action :require_admin
  def show
    client = Mysql2::Client.new(:host => "localhost", :username => "root")
    client.query("use BookStore")

    top5customers = "select SUM(transactions.total_price) as sales,users.username,users.id,users.address from books JOIN transactions ON books.id = transactions.book_id JOIN users ON users.id = transactions.user_id WHERE DATE(created_at) > DATE(CURRENT_DATE - INTERVAL 3 MONTH) group by user_id order by sales DESC LIMIT 5;"
    top5 = client.query(top5customers)
    @top5 = []
    top5.each do |rec|
      @top5.append(rec)
      puts rec
    end

    top10books = "select SUM(transactions.total_price) as sales,books.id,books.isbn,books.title,books.category,books.stock from books JOIN transactions ON books.id = transactions.book_id
                  WHERE DATE(created_at) > DATE(CURRENT_DATE - INTERVAL 3 MONTH)
                  GROUP BY books.id
                  ORDER BY sales DESC LIMIT 10;"

    top10 = client.query(top10books)
    @top10 = []
    top10.each do |rec|
      @top10.append(rec)
      puts rec
    end


    prevMon = "select SUM(transactions.total_price) from books JOIN transactions ON books.id = transactions.book_id WHERE DATE(created_at) > DATE(CURRENT_DATE - INTERVAL 1 MONTH);"
    prevSales = client.query(prevMon)
    @prev = []
    prevSales.each do |rec|
      @prev.append(rec)
    end
    puts "PDF STARTS HERE"
    puts @prev[0]["SUM(transactions.total_price)"]
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportPdf.new(@prev[0]["SUM(transactions.total_price)"],@top10,@top5)
        send_data pdf.render, filename: "report_#{Time.now}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end

  end
end