class Reservation_listPdf < Prawn::Document
  def initialize(accessions, view, college)
    super({top_margin: 50, left_margin: 50, page_size: 'A4', page_layout: :landscape })
    @accessions = accessions
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
    table(line_item_rows, :column_widths => [30, 130, 80, 45, 150, 60, 45, 150, 70], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(3).align = :center
      column(5..6).align = :center
      column(8).align = :center
      self.width=760
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('library.reservation.list').upcase}<br> #{@college.name.upcase}", colspan: 9}],
              [ 'No', I18n.t('library.book.title'), I18n.t('library.reservation.accession_no'), "#{I18n.t('library.reservation.staff')} / #{I18n.t('library.reservation.student')}",  I18n.t('library.reservation.borrowed_by'), I18n.t('library.reservation.returnduedate'), "#{I18n.t('library.reservation.staff')} / #{I18n.t('library.reservation.student')}", I18n.t('library.reservation.reserved_by'), "#{I18n.t('library.reservation.reservation_date')} #{I18n.t ('library.reservation.expired_reservation')}"]]
    body=[]
    @accessions.each do |accession|
      #borrower section
      loan=Librarytransaction.where(accession_id: accession.id).last
      if loan.ru_staff==true
        borrower=loan.staff.staff_with_rank
        usrtype=I18n.t('library.reservation.staff')
      elsif loan.ru_staff==false
        borrower=loan.student.student_with_rank
        usrtype=I18n.t('library.reservation.student')
      end
      count=0
 
      unless accession.reservations.blank?
        for reserve in accession.reservations.values
          #reserver section
          user_rec=User.find(reserve["reserved_by"].to_i)
          if user_rec.userable_type=="Staff"
            reserver=user_rec.userable.staff_with_rank
            reservertype=I18n.t('library.reservation.staff')
          elsif user_rec.userable_type=="Student"
            reserver=user_rec.userable.student_with_rank
            reservertype=I18n.t('library.reservation.student')
          end

          rspan=accession.reservations.values.count
          if count==0
              body << [{content: "#{counter += 1}", rowspan: rspan}, {content: "#{accession.book.title}", rowspan: rspan}, {content: "#{accession.accession_no}", rowspan: rspan},{content: "#{usrtype}", rowspan: rspan},{content: "#{borrower}", rowspan: rspan},{content: "#{loan.returned==true ? "-" : loan.returnduedate.strftime('%d-%m-%Y')}", rowspan: rspan} ,reservertype, "#{count+1}) #{reserver} <br> #{I18n.t('library.reservation.expired_date') if loan.returned==true}", "#{reserve["reservation_date"]}<br><br> #{(loan.returneddate+3.days).strftime('%d-%m-%Y') if loan.returned==true}"]
          else
              body << [reservertype, "#{count+1}) #{reserver}", reserve["reservation_date"]]
          end
          count+=1
        end
      end

    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [730,-5]
  end

end