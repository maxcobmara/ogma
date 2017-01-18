class Weeklytimetable_reportPdf < Prawn::Document
  def initialize(weeklytimetables, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @weeklytimetables = weeklytimetables
    @view = view
    @college=college
    font "Helvetica"
    record
  end
  
  def record
    if @college.code=='amsas'
      columnwidth=[30, 130, 70, 60, 60, 160, 70, 120, 60]
    else
      columnwidth=[30, 130, 60, 60, 60, 50 ,120, 70, 120, 60]
    end
    table(line_item_rows, :column_widths => columnwidth, :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      #self.width = 720
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    if @college.code=='amsas'
      coltospan=9
    else
      coltospan=10
    end
    header = [[{content: "#{I18n.t('training.weeklytimetable.list').upcase}<br> #{@college.name.upcase}", colspan: coltospan}]]
    head_a= [ 'No', I18n.t('training.weeklytimetable.programme_id'), I18n.t('training.weeklytimetable.intake_id'), I18n.t('training.weeklytimetable.startdate'), I18n.t('training.weeklytimetable.enddate')]
    head_b=[I18n.t('training.weeklytimetable.semester')]
    head_c=[I18n.t('training.weeklytimetable.prepared_by'), I18n.t('training.weeklytimetable.is_submitted'), I18n.t('training.weeklytimetable.endorser'), I18n.t('training.weeklytimetable.is_approved')]
    if @college.code=='amsas'
      header << head_a+head_c
    else
      header << head_a+head_b+head_c
    end
    
    body=[]
    @weeklytimetables.group_by{|x|x.programme_id}.each do |p,weeklytimetables|
        weeklytimetables.each do |wt|
	  a= ["#{counter += 1}", wt.try(:schedule_programme).try(:programme_list), "#{wt.college.code=="amsas"? wt.schedule_intake.siri_name : wt.schedule_intake.group_with_intake_name}",wt.try(:startdate).try(:strftime, "%d-%m-%Y") , wt.try(:enddate).try(:strftime, "%d-%m-%Y")] 
	  b=[wt.try(:academic_semester).try(:semester)]
	  c=["#{wt.try(:schedule_creator).rank_id? ? wt.try(:schedule_creator).staff_with_rank  :  wt.try(:schedule_creator).try(:name) }","#{wt.is_submitted? ? I18n.t('yes2') : I18n.t('no2')} <br> #{I18n.t('training.weeklytimetable.is_returned') if wt.hod_rejected==true && wt.is_submitted==nil }#{I18n.t('training.weeklytimetable.is_resubmitted') if wt.hod_rejected_on!=nil && wt.is_submitted==true && wt.hod_approved!=true}", wt.schedule_approver.try(:staff_with_rank),"#{wt.hod_approved? ? I18n.t('yes2') : I18n.t('no2')}  #{wt.hod_rejected? ? '- '+I18n.t('rejected') : '' }"]
	  if @college.code=='amsas'
	    body << a+c
	  else
            body << a+b+c
	  end
        end
     end
     header+body
  end
end