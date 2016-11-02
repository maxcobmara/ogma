class Lessonplan_listingPdf < Prawn::Document
  def initialize(lesson_plans, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @lesson_plans = lesson_plans
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
    rec_count=[3]
    cnt=1
    @lesson_plans.group_by(&:lecturer).each do |lecturer, lps|
      rec_count << (rec_count[cnt-1]+lps.count+1)
      cnt+=1
    end
    table(line_item_rows, :column_widths => [30, 45, 45, 150, 150, 60, 65, 55, 60, 55, 55], :cell_style => { :size => 9,  :inline_format => :true}, :header => 3) do
      row(0..1).borders =[]
      row(0).height=40
      row(0).style size: 11
      row(0).align = :center
      row(0).font_style = :bold
      row(2).font_style = :bold
      row(2).background_color = 'FFE34D'
      self.width = 770
      for cnt in rec_count
        row(cnt).align =:center
        row(cnt).background_color='FDF8A1'
        row(cnt).font_style =:bold
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('training.lesson_plan.title').upcase}<br> #{@college.name.upcase}", colspan: 11}], [ "", "", "", "", "", "", "", "", "", "", ""],
              [ 'No', "#{I18n.t('training.lesson_plan.intake')}<br>#{I18n.t('training.lesson_plan.year') if @college.code!='amsas'} #{'Sem' if @college.code!='amsas'}", I18n.t('training.lesson_plan.student_qty'), I18n.t('training.lesson_plan.topic'), I18n.t('training.lesson_plan.lecture_title'), I18n.t('training.lesson_plan.lecture_date'), "#{ I18n.t('training.lesson_plan.start_time')}<br>#{I18n.t('training.lesson_plan.end_time')}", I18n.t('training.lesson_plan.is_submitted2'), I18n.t('training.lesson_plan.hod_approved3'), I18n.t('training.lesson_plan.report_submit2'), I18n.t('training.lesson_plan.report_endorsed2')]]
    body=[]
    @lesson_plans.group_by(&:lecturer).each do |lecturer, lps|
        body << [{content: "#{Staff.find(lecturer).staff_with_rank}", colspan: 11} ]
        for lp in lps
          if @college.code=='amsas'
            intake=lp.lessonplan_intake.monthyear_intake.strftime('%m/%Y')
          else
            intake="#{lp.lessonplan_intake.monthyear_intake.strftime('%b%Y')}<br>#{lp.try(:year)} #{lp.try(:sem)}"
          end
           body << ["#{counter += 1}", intake, lp.student_qty,"#{ lp.schedule_item.try(:weeklytimetable_topic).try(:subject_list).to_s} -#{lp.schedule_item.try(:render_class_method).try(:first)}", lp.lecture_title, lp.try(:lecture_date).try(:strftime, '%d-%m-%Y'), "#{lp.try(:start_time).try(:strftime, '%H:%M')} - #{lp.try(:end_time).try(:strftime, '%H:%M')}", "#{lp.is_submitted? ? I18n.t('yes2') : I18n.t('no2')}", "#{lp.hod_approved? ? I18n.t('yes2') : I18n.t('no2')}#{lp.hod_rejected? ? '- '+I18n.t('rejected') : ''}", "#{lp.report_submit? ? I18n.t('yes2') : I18n.t('no2')}", "#{lp.report_endorsed? ? I18n.t('yes2') : I18n.t('no2')}"]
	end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [750,-5]
  end

end