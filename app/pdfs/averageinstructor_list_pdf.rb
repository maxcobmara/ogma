class Averageinstructor_listPdf < Prawn::Document
  def initialize(average_instructors, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @average_instructors = average_instructors
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
    row_counts=[]
    rowno=2
    recs_per_prog=0
    @average_instructors.group_by(&:programme).each do |programme, average_instructors|
      row_counts << rowno+recs_per_prog
      recs_per_prog+=average_instructors.count+1
    end
    table(line_item_rows, :column_widths => [30, 90, 60, 60, 170, 50,70],  :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width=530
      for row_count in row_counts
        row(row_count).font_style=:bold
	row(row_count).align =:center
	row(row_count).background_color='FDF8A1'
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('average_instructor.list').upcase}<br> #{@college.name.upcase}", colspan: 7}],
              [ 'No', I18n.t('average_instructor.instructor_id'), I18n.t('average_instructor.evaluate_date'), I18n.t('average_instructor.title2'), I18n.t('average_instructor.objective'), I18n.t('average_instructor.delivery_type'), I18n.t('average_instructor.evaluator_id')]]
    body=[]
    @average_instructors.group_by(&:programme).each do |programme, average_instructors|
         body << [{content: programme.try(:programme_list), colspan: 7}]
         for average_instructor in average_instructors
            body << ["#{counter += 1}", average_instructor.instructor.staff_with_rank, average_instructor.evaluate_date.try(:strftime, '%d-%m-%Y'), average_instructor.title, average_instructor.objective, average_instructor.render_delivery, average_instructor.evaluator.try(:staff_with_rank)]
        end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end