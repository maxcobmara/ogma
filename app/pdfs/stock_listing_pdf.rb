class Stock_listingPdf < Prawn::Document
  def initialize(all_accessions, search, params_count, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @all_accessions = all_accessions
    @view = view
    @college=college
    @search=search
    @params_count=params_count
    font "Helvetica"
    record
  end
  
  def record
    aaa=@all_accessions.count
    x=2
    table(line_item_rows, :column_widths => [100, 15, 100, 100, 15, 100, 90], :cell_style => { :size => 10,  :inline_format => :true}, :header => 2) do
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.width = 520
      row(0..1).borders =[]
      row(0..1).height=40
      row(0).style size: 12
      row(0).align = :center
      row(0..1).font_style = :bold
      
      0.upto(aaa-1).each do |rec|
        row(x+5*rec).borders=[:top]
        row(x+5*rec).height=25
        row(x+5*rec).style :valign => :bottom
        row(x+5*rec+1..x+5*rec+3).borders=[]
        row(x+5*rec+3).height=25
        row(x+5*rec+4).borders=[:top]
        row(x+5*rec+4).height=20
      end
#       row(2).borders=[:top]
#       row(2).height=25
#       row(2).style :valign => :bottom
#       row(3..5).borders=[]
#       row(5).height=25
#       row(6).borders=[:top]
#       row(6).height=20
      
#        row(x+5*0).borders=[:top]
#       row(x+5*0).height=25
#       row(x+5*0).style :valign => :bottom
#       row(x+5*0+1..x+5*0+3).borders=[]
#       row(x+5*0+3).height=25
#       row(x+5*0+4).borders=[:top]
#       row(x+5*0+4).height=20

    end
  end
 
  def line_item_rows
    counter = counter || 0
    title_row="#{I18n.t('library.book.total_books_titles')} : #{@all_accessions.count} / #{@all_accessions.group_by(&:book_id).count}"
    if !@search.accessionno_from.blank? && !@search.accessionno_to.blank? && @params_count==2
      #search by accession_no
      title_row+=" - #{I18n.t('library.book.stock_listing_accession')} (#{I18n.t('library.book.range')} : #{@search.accessionno_from} - #{@search.accessionno_to})"
    elsif !@search.classlcc_cont.blank? && @params_count==1
      #search by call no (NLM/LC)
      title_row+=" - #{I18n.t('library.book.stock_listing')} #{I18n.t('library.book.started_with')} <b><i>#{@search.classlcc_cont.upcase}</i></b>"
    end
    header = [[{content: "#{@college.name.upcase}<br>#{I18n.t('library.book.stock_listing').upcase}", colspan: 7}],
                    [{content: title_row, colspan: 7}]]
    
    body=[]
      @all_accessions.each do |acc|
        if acc.book.photo.exists? then
	  #subtable=make_table([[{:image => "#{Rails.root}/public#{acc.book.photo.url(:thumbnail).split('?').first}"}]])
          #subtable=make_table([[{:image => "#{Rails.root}/public#{acc.book.photo.url.split('?').first}", :scale => 0.3}]])
	  sub_data = [[{:image => "#{Rails.root}/public#{acc.book.photo.url.split('?').first}", :scale => 0.3}]]
	  subtable=make_table(sub_data, :column_widths => [70], :position => :center) do
	    row(0).borders=[]
	  end
	else
	  subtable=I18n.t('library.book.no_image')
	end
        body << [I18n.t('library.book.classno'),":", acc.book.classlcc, I18n.t('library.book.accessionno'), ":", acc.accession_no, {content:  subtable, rowspan: 4}] 
        body << ["ISBN/ISSN",":", acc.book.isbn, I18n.t('library.book.physical_description'),":","#{acc.book.roman}X#{acc.book.size}X#{acc.book.pages}"] 
	body << [I18n.t('library.book.catsource'), ":", (DropDown::CATSOURCE.find_all{|disp, value| value == acc.book.catsource.to_i}).map {|disp, value| disp}[0], "#{I18n.t('library.book.series')}/#{I18n.t('library.book.edition')} ", ":", "#{acc.book.series}/#{acc.book.edition}"]
        body << ["Imprint", ":", {content: "#{acc.book.publish_location}, #{acc.book.publisher},  #{acc.book.publish_date}", colspan: 4}]
        body << ["","","","","","",""] 
      end
      header+body
    end
end