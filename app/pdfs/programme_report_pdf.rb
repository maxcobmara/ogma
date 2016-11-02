class Programme_reportPdf < Prawn::Document
  def initialize(programmes, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @programmes = programmes
    @view = view
    @college=college
    font "Helvetica"
    record
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

    table(line_item_rows, :column_widths => [30, 20, 20, 20, 20, 20, 20, 180], :cell_style => { :size => 9,  :inline_format => :true, :padding => [3,0,0,0]}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(0).align =:center
      row(2..row_count+3).borders=[]
      for cnt in rec_count
	if cnt==1
	  row(cnt).columns(0).borders=[:left, :bottom, :top]
	  row(cnt).columns(1).borders=[:right, :bottom, :top]
	  row(cnt).height=20
	else
	  row(cnt).borders=[:bottom]
	  row(cnt).height=20 
	end
	row(cnt).valign =:middle
      end
    end
  end
  
#    (t 'training.programme.combo_code')
#     %span.credits= (t 'training.programme.credits')
#     %span.status=  (t 'training.programme.status')
#     %span.duration= (t 'training.programme.duration')
#     %span.lecture= (t 'training.programme.lecture')
#     %span.tutorial= (t 'training.programme.tutorial')
#     %span.practical= (t 'training.programme.practical')
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('training.programme.title').upcase}<br> #{@college.name.upcase}", colspan: 8}], 
              [ 'No', {content: I18n.t('training.programme.combo_code'), colspan: 7}], ["","","","","","","",""]]
    body=[]
    level=@programmes.pluck(:ancestry_depth).max #5
    @programmes.group_by(&:root_id).sort.each do |course, programmes| 
         #1st level
         programme=Programme.find(course)
         body << ["#{counter += 1}", {content: "<b>#{programme.programme_list.upcase}</b>", colspan: 7}]
	 #2nd level
	 count=0
	 programme.descendants.at_depth(1).sort_by(&:code).each do |semester|
           body << ["", "",{content: "#{count+=1}) #{semester.subject_list if semester.course_type=='Subject'}#{semester.name if semester.course_type=='Semester'}", colspan: 6}] 
	   
	   #####
           #3rd level
# 	   semester.descendants.at_depth(2).sort_by(&:code).each do |subject|
# 	     body << ["", "", "", {content: "#{subject.subject_list}", colspan: 5}]
# 	     #4th level
# 	     subject.descendants.at_depth(3).sort_by(&:code).each do |topic|
# 	       body << ["", "", "", "", {content: "#{topic.subject_list}", colspan: 4}]
# 	       #5th level
# 	       topic.descendants.at_depth(4).sort_by(&:code).each do |subtopic|
# 		 body << ["","","","","",{content: "#{subtopic.subject_list}", colspan: 3}]
# 		 #6th level
# 	         subtopic.descendants.at_depth(5).sort_by(&:code).each do |subsubtopic|
# 		   body << ["","","","","", "", {content: "#{subsubtopic.subject_list}", colspan: 2}]
# 	         end
# 	       end
# 	     end
# 	   end
	   #####7th level(kskbjb), 6th level(amsas)
	   2.upto(level).each do |counting|
             semester.descendants.at_depth(counting).sort_by(&:code).each do |childnode|
	       body << [{content: "", colspan: counting+1}, {content: "- #{childnode.subject_list}", colspan: 8-(counting+1)}]
	     end
	   end
           
         end
	 body << [{content: "", colspan: 8}]
    end
    header+body
  end

end