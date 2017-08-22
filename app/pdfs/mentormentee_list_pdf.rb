class Mentormentee_listPdf < Prawn::Document
  def initialize(mentors, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @mentors = mentors
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
    table(line_item_rows, :column_widths => [30, 130, 60, 200, 100], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width = 520
    end
  end

  def line_item_rows
    counter = counter||0
    header=[[{content: "#{I18n.t('staff.mentors.title').upcase}<br> #{@college.name.upcase}", colspan: 5}],
            ["No", I18n.t('staff.mentors.staff_id'), I18n.t('staff.mentors.mentor_date'), I18n.t('staff.mentors.mentee'), I18n.t('staff.mentors.remark')]]
    body=[]
    @mentors.uniq.each do |mentor|
      counter2=counter2||0
      m_list=""
      Mentor.find(mentor.id).mentees.map{|x|x.student.student_with_rank}.each{|m|m_list+="(#{counter2+=1}) "+m+"<br>"}
      body <<  ["#{counter+=1}", mentor.staff.staff_with_rank, mentor.mentor_date.try(:strftime, '%d-%m-%Y'), m_list, mentor.remark]
#         for mentee in Student.where(id: mentor.mentees.pluck(:student_id))
#           ["#{counter+=1}",  ]
#         end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end