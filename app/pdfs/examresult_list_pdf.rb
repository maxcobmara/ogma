class Examresult_listPdf < Prawn::Document
  def initialize(examresults, view, college)
    super({top_margin: 50, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @examresults = examresults
    if college.code=="kskbjb"
      @grouping=examresults.group_by{|x|x.intake_group}
    elsif college.code=="amsas"
      @grouping=examresults.group_by(&:intake_id)
    end
    @view = view
    @college=college
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    if @college.code=='amsas'
      columns_set= [50, 250, 100, 100]
    else
      columns_set= [30, 250, 100, 100, 60]
    end
    row_count=0
    intake_rows=[]
    programme_rows=[]
    intake_count=0
    @grouping.each do |intake, examresults|
        intake_rows << intake_count+2+row_count
        examresults.group_by {|y|y.programmestudent.programme_list}.each do |programme, examresults2|
	  programme_rows << intake_count+2+row_count+1
	  row_count+=examresults2.count+1
        end
        intake_count+=1
    end
    table(line_item_rows, :column_widths => columns_set, :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      for intake_row in intake_rows
        row(intake_row).background_color = 'FDF8A1'
	row(intake_row).align =:center
	row(intake_row).font_style =:bold
      end
      for programme_row in programme_rows
	row(programme_row).background_color = 'E1DD8A'
	row(programme_row).align =:center
	row(programme_row).font_style=:bold
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    if @college.code=='kskbjb'
      header_title+=["Semester"]
      total_columns=5
    else
      total_columns=4
    end
    header = [[{content: "#{I18n.t('exam.examresult.title').upcase}<br> #{@college.name.upcase}", colspan: total_columns}]]
    header_title=['No', I18n.t('exam.examresult.programme_id'), I18n.t('exam.examresult.examdts'), I18n.t('exam.examresult.examdte')]
    header << header_title
    body=[]
    @grouping.each do |intake, examresults|
        intake_line="#{I18n.t('exam.examresult.intake')} : "
        if @college.code=='kskbjb'
          intake_line+=" #{Date.new(intake[0,4].to_i, intake[5,2].to_i, intake[8,2].to_i).try(:strftime, '%b %Y').upcase}"
	else
          intake_line+=" Siri #{Intake.find(intake).monthyear_intake.try(:strftime, '%m/%Y').upcase}"
	end
        body << [{content: "#{intake_line}", colspan: total_columns}] 
	examresults.group_by {|y|y.programmestudent.programme_list}.each do |programme, examresults2|
	    body <<  [{content: "#{programme}", colspan: total_columns}] 
	    for examresult in examresults2.sort_by{|x|x.semester}
	        a= ["#{counter += 1}", examresult.programmestudent.programme_list,  @view.l(examresult.examdts), @view. l(examresult.examdts)]
		if @college.code=='kskbjb'
	          body << a+[examresult.render_semester]
		else
		  body << a
		end
	    end
	end

    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end