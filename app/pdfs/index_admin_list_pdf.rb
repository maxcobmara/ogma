class Index_admin_listPdf < Prawn::Document
  def initialize(fingerprints, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @fingerprints = fingerprints
    @view = view
    @college=college
    font "Helvetica"
    retrieve_data
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def retrieve_data
    counter = counter||0
    body=[]
    arr=Array.new
    if @fingerprints.size > 0
        @fingerprints.each do |fingerprint|
            if fingerprint.ftype!=3
                fdate_start=fingerprint.fdate.to_time.beginning_of_day
                fdate_end=fingerprint.fdate.to_time.end_of_day
                sa_rec_in = StaffAttendance.where('logged_at>=? and logged_at<=?', fdate_start, fdate_end).where('log_type=? or log_type=?', 'I','i').where(thumb_id: fingerprint.thumb_id)
                sa_rec_out = StaffAttendance.where('logged_at>=? and logged_at<=?', fdate_start, fdate_end).where('log_type=? or log_type=?', 'O','o').where(thumb_id: fingerprint.thumb_id)
	    end
	    if fingerprint.ftype==1 || fingerprint.ftype==3
                time_in=I18n.t('fingerprint.no_record')
		arr << "#{counter+2}, 2"
	    else
	        time_in=sa_rec_in.first.logged_at.strftime('%H:%M')
	    end
	    if fingerprint.ftype==2 || fingerprint.ftype==3
               time_out=I18n.t('fingerprint.no_record') 
	       arr << "#{counter+2}, 3"
	    else
	       time_out=sa_rec_out.first.logged_at.strftime('%H:%M')
	    end
	    if fingerprint.is_approved == true
	       status=I18n.t('approved')
	    elsif fingerprint.is_approved == false
	       status=I18n.t('not_approved')
	    end
	    status=I18n.t('not_approved')
            body << ["#{counter+=1}", fingerprint.fdate.try(:strftime, '%d-%m-%Y'), time_in, time_out, fingerprint.owner.staff_with_rank_position_unit, fingerprint.reason, "#{fingerprint.approved_by.blank? ? "" : fingerprint.try(:approver).try(:staff_with_rank_position_unit)}", status]
        end
    end
    
    @body=body
    @no_record_cells=arr
  end

  def record
    total_records=@fingerprints.count
    no_record_cells=@no_record_cells
    table(line_item_rows, :column_widths => [30, 60, 45, 45, 100, 90, 95, 55], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      row(2..total_records+2).columns(2..3).align=:center
      for acell in no_record_cells
	arow, acol=acell.split(",")
	row(arow.to_i).column(acol.to_i).text_color ='EC0C16'
      end
      self.width = 520
    end
  end
  
  def line_item_rows
    body=@body
    header=[[{content: "#{I18n.t('fingerprint.title3').upcase}<br> #{@college.name.upcase}", colspan: 8}],
            ["No", I18n.t('attendance.attdate'), I18n.t('attendance.time_in'), I18n.t('attendance.time_out'), I18n.t('attendance.staff_id'), I18n.t('attendance.reason'), I18n.t('attendance.approve_id'), I18n.t('attendance.approvestatus')]]
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end