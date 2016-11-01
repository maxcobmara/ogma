class Intake_reportPdf < Prawn::Document
  def initialize(intakes, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @intakes = intakes
    @view = view
    @college=college
    font "Helvetica"
    record
  end
  
  def record
    rec_count=[2]
    cnt=1
    @intakes.each do |intk, details|
      rec_count << (rec_count[cnt-1]+details.count+1)
      cnt+=1
    end
    table(line_item_rows, :column_widths => [30, 60, 70, 180, 140,40], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      for cnt in rec_count
        row(cnt).align =:center
        row(cnt).background_color='FDF8A1'
        row(cnt).font_style =:bold
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('training.intake.list').upcase}<br> #{@college.name.upcase}", colspan: 6}],
              [ 'No', I18n.t('training.intake.description'), I18n.t('training.intake.register_on'), I18n.t('training.intake.programme_id'), I18n.t('training.intake.staff_id'), I18n.t('training.intake.is_active')]]
    body=[]
    @intakes.each do |intakedate,intakedetails|
          body << [{content: @college.code=="amsas"? "Siri "+intakedate.strftime('%m / %Y') : intakedate.strftime('%b %Y'), colspan: 6}]
          intakedetails.each do |details|
              body << ["#{counter += 1}", details.description, details.register_on.try(:strftime, '%d-%m-%Y'), details.programme.programme_list, details.coordinator.try(:staff_with_rank), "#{details.is_active? ? I18n.t('yes2') : I18n.t('no2')}" ]
          end
     end
     header+body
  end
end