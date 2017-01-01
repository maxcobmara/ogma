class Intake_reportPdf < Prawn::Document
  def initialize(intakes, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @intakes = intakes
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
    if @college.code!="amsas"
      rec_count=[2]
      cnt=1
      @intakes.each do |intk, details|
        rec_count << (rec_count[cnt-1]+details.count+1)
        cnt+=1
      end
    end
    college_code=@college.code
    if college_code=="amsas"
      columnswidth=[30, 40, 110, 60, 140, 100,40]
    else
      columnswidth=[30, 60, 70, 180, 140,40]
    end
    table(line_item_rows, :column_widths => columnswidth, :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      if college_code!="amsas"
        for cnt in rec_count
          row(cnt).align =:center
          row(cnt).background_color='FDF8A1'
          row(cnt).font_style =:bold
        end
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    if @college.code=="amsas"
      hh= ['No', 'Siri', I18n.t('training.intake.division_name')]
    else
      hh=['No', I18n.t('training.intake.description')]
    end
    header = [[{content: "#{I18n.t('training.intake.list').upcase}<br> #{@college.name.upcase}", colspan: 6}],
              hh+[I18n.t('training.intake.register_on'), I18n.t('training.intake.programme_id'), I18n.t('training.intake.staff_id'), I18n.t('training.intake.is_active')]]
    body=[]
    @intakes.each do |intakedate,intakedetails|
          if @college.code!="amsas"
            body << [{content: intakedate.strftime('%b %Y'), colspan: 6}]
	  end
          intakedetails.each do |details|
	      div_details=""
	      if details.description.to_i > 0
                0.upto(details.description.to_i-1) do |x|
                  div_details+="(#{x+1}) #{details.division[x.to_s]["name"]} - #{details.division[x.to_s]["total_student"]} #{I18n.t('training.intake.person')}<br>"
                end 
              else
                div_details="#{I18n.t('not_applicable')}"
              end
	      if @college.code=="amsas"
		aa=["#{counter += 1}", details.name, div_details]
              else
		aa=["#{counter += 1}", details.description]
	      end
              body << aa+[details.register_on.try(:strftime, '%d-%m-%Y'), details.programme.programme_list, details.coordinator.try(:staff_with_rank), "#{details.is_active? ? I18n.t('yes2') : I18n.t('no2')}" ]
          end
     end
     header+body
  end

  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end
  
end