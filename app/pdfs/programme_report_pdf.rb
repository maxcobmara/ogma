class Programme_reportPdf < Prawn::Document
  def initialize(programmes, view, college)
    super({top_margin: 30, page_size: 'A4', page_layout: :portrait })
    @programmes = programmes
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
    #tlbr
    row_count=@programmes.count+5
    rec_count=[1]
    cnt=1
    @programmes.group_by(&:root_id).sort.each do |course, programmes| 
      if cnt == 1
        rec_count << (rec_count[cnt-1]+Programme.find(course).descendants.count+3) 
      else
        rec_count << (rec_count[cnt-1]+Programme.find(course).descendants.count+2) 
      end
      cnt+=1
    end

    table(line_item_rows, :column_widths => [30, 20, 20, 20, 20, 20, 20, 165, 30, 30, 35, 35, 35, 40], :cell_style => { :size => 9,  :inline_format => :true, :padding => [2,3,1,0]}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0).valign = :top
      row(0..1).font_style = :bold
      #row(1).column(8..13).align =:center
      column(8..13).align =:center
      column(8..13).style size: 8
      row(1).column(8..13).style size: 8
      row(1).background_color = 'FFE34D'
      column(0).align =:center
      row(2..row_count+3).column(0).borders=[:left]
      row(2..row_count+3).column(13).borders=[:right]
      row(2..row_count+3).column(1..12).borders=[]
      #row(2..row_count+3).borders=[]
      for cnt in rec_count
	if cnt==1
	  row(cnt).columns(0).borders=[:left, :bottom, :top]
	  row(cnt).columns(1).borders=[:right, :bottom, :top]
	  row(cnt).height=30
	else
	  row(cnt).borders=[:bottom, :left, :right]
	  #row(cnt).borders=[:bottom]
	  row(cnt).height=20 
	end
	row(cnt).valign =:middle
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('training.programme.title').upcase}<br>#{@college.name.upcase}", colspan: 8+6}], 
              [ 'No', {content: I18n.t('training.programme.combo_code'), colspan: 7}, I18n.t('training.programme.credits'),"Status", I18n.t('training.programme.duration'), I18n.t('training.programme.lecture'), I18n.t('training.programme.tutorial'), I18n.t('training.programme.practical')], ["","","","","","","","","","","","","",""]]
    body=[]
    level=@programmes.pluck(:ancestry_depth).max #5
    @programmes.group_by(&:root_id).sort.each do |course, programmes| 
         #1st level
         programme=Programme.find(course)
         body << ["#{counter += 1}", {content: "<b>#{programme.programme_list.upcase}</b>", colspan: 7}, programme.credits, programme.render_status, programme.total_duration2, "", "", ""]
	 #2nd level
	 count=0
	 programme.descendants.at_depth(1).sort_by(&:code).each do |node|
           body << ["", "",{content: "#{count+=1}) #{node.subject_list if node.course_type=='Subject'}#{node.name if node.course_type=='Semester'}", colspan: 6}, node.credits, node.render_status, node.total_duration2, "#{node.lecture_d.blank? ? '-' : node.lecture_d.try(:strftime, '%H:%M')}", "#{node.tutorial.blank? ? '-' : node.tutorial_d.try(:strftime, '%H:%M') }", "#{node.practical_d.blank? ? '-' : node.practical_d.try(:strftime, '%H:%M')}"] 

	   #####7th level(kskbjb), 6th level(amsas)
	   2.upto(level).each do |counting|
             node.descendants.at_depth(counting).sort_by(&:code).each do |childnode|
               body << [{content: "", colspan: counting+1}, {content: "- #{childnode.subject_list}", colspan: 8-(counting+1)}, childnode.credits, childnode.render_status, childnode.total_duration2,  "#{childnode.lecture_d.blank? ? '-' : childnode.lecture_d.try(:strftime, '%H:%M')}", "#{childnode.tutorial.blank? ? '-' : childnode.tutorial_d.try(:strftime, '%H:%M') }", "#{childnode.practical_d.blank? ? '-' : childnode.practical_d.try(:strftime, '%H:%M')}"]
	     end
	   end
           
         end
	 body << [{content: "", colspan: 8+6}]
    end
    header+body
  end
  
  def footer
    stroke do
      horizontal_line 0, 520, :at => bounds.bottom+8
    end
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-10]
    draw_text "#{I18n.t('time.legend')} #{I18n.t('time.legend2')}", :size => 7, :at => [10, -10], :style => :italic
  end

end