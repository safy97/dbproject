class ReportPdf < Prawn::Document
  def initialize(prev, top10,top5)
    @prev = prev
    @top5 = top5
    @top10 = top10
    super(top_margin: 70)
    text("Report ---- #{DateTime.now.strftime('%a, %d %b %Y %H:%M:%S')}")
    text("________________________________________________________________________________")
    move_down 10
    text("TOP 5 Users Last 3 Months",size: 25)

    #top5table = make_table([ ["Username","ID","Sales"]])
    myrows = [["Sales","Username","ID","Address"]]
    @top5.each do |user|
      arr = []
      user.each do |key,value|
        arr.append(value)
      end
      myrows.append(arr)
    end
    top5table = make_table(myrows)
    top5table.draw
    text("________________________________________________________________________________")
    move_down 20
    text("TOP 10 Books Last 3 Months",size: 25)

    #top5table = make_table([ ["Username","ID","Sales"]])
    myrows = [["Sales","ID","ISBN","Title","Category","Stock"]]
    @top10.each do |user|
      arr = []
      user.each do |key,value|
        arr.append(value)
      end
      myrows.append(arr)
    end
    top5table = make_table(myrows)
    top5table.draw
    text("________________________________________________________________________________")
    move_down 20
    text("Total Sales Last Month                $"+@prev.to_s,size: 15)
  end
end