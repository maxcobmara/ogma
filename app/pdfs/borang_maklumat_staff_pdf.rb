class Borang_maklumat_staffPdf < Prawn::Document
  def initialize(staff, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @staff = staff
    @view = view

    
    
    font "Times-Roman"
    text "KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :center, :size => 14, :style => :bold
    move_down 5
    text "BORANG MAKLUMAT STAFF BAGI SISTEM ICMS", :align => :center, :size => 14, :style => :bold
    move_down 20
    table1
    table2
    table_qualification
    table_loan
    table3
    table4
    
  end
  
    def table1
      
      data =[["Butiran Peribadi", ""],
            ["1. MyKad No", ": #{@staff.icno}"],
            ["2. Nama", ": #{@staff.name}"],
            ["3. Staff Code", ": #{@staff.code}"],
            ["4. No Fail Peribadi", ": #{@staff.fileno}"],
            ["5. Jawatan",": #{@staff.positions.name}"],
            ["6. Email", ": #{@staff.coemail}"],
            ["7. Tarikh Lahir", ": #{@staff.cobirthdt}"],
            ["8. No Surat Beranak", ": #{@staff.birthcertno}"],
            ["9. Umur",": #{@staff.age}"],
            ["10. Jenis Darah", ": #{(DropDown::BLOOD_TYPE.find_all{|disp, value| value == @staff.bloodtype}).map {|disp, value| disp}[0]}"],
            ["11. Jantina", ": #{(DropDown::GENDER.find_all{|disp, value| value == @staff.gender.to_s}).map {|disp, value| disp}[0]}"],
            ["12. Telefon", ": #{@staff.cooftelno} , #{@staff.cooftelext} , #{@staff.phonecell}" ],
            ["13. Alamat", ": #{@staff.addr}"],
            ["14. Poskod", ": #{@staff.poskod_id}"],
            ["15. Taraf Perkahwinan",": #{(DropDown::MARITAL_STATUS.find_all{|disp, value| value == @staff.mrtlstatuscd }).map {|disp, value| disp}[0]}"],
            ["16. Negeri Dilahirkan", ": #{(DropDown::STATECD.find_all{|disp, value| value == @staff.statecd}).map {|disp, value| disp}[0]}"],
            ["17. Bangsa", ": #{(DropDown::RACE.find_all{|disp, value| value == @staff.race}).map {|disp, value| disp}[0]}"],
            ["18. Agama", ": #{(DropDown::RELIGION.find_all{|disp, value| value == @staff.religion}).map {|disp, value| disp}[0]}"],
            ["19. Kewarganegaraan", ": #{(DropDown::NATIONALITY.find_all{|disp, value| value == @staff.country_cd}).map {|disp, value| disp}[0]}"],
            ["20. Kelas Pengankutan", ": #{@staff.transportclass_id}" ],
            ["21. No Cukai Pendapatan",": #{@staff.taxcode}"],
            ["22. No Akaun Bank", ": #{@staff.bankaccno}"],
            ["23. Nama Bank", ": #{@staff.bank}"],
            ["24. Jenis Akaun",": #{@staff.bankacctype}"]]
            
            table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
              a = 0
              b = 25
              row(0).font_style = :bold
              row(0).background_color = 'FFE34D'
              while a < b do
              row(a).borders = []
              a += 1
            end
              
            end
          move_down 10
         end
  
         def table2
      
           data =[[" Butiran Pekerjaan", ""],
                 ["26. Gred Jawatan", ": #{@staff.staffgrade.name_and_group}"],
                 ["27. Jawatan", ": #{@staff.positions.name}"],
                 ["28. Melapor Kepada", ": #{@staff.positions.first.try(:parent).try(:staff).try(:name)}"],
                 ["29. Status Pekerjaan",": #{(DropDown::STAFF_STATUS.find_all{|disp, value| value == @staff.employstatus}).map {|disp, value| disp}[0]}"],
                 ["30. Status Lantikan", ": #{(DropDown::APPOINTMENT.find_all{|disp, value| value == @staff.appointstatus.to_s}).map {|disp, value| disp}[0]}"],
                 ["31. Tarikh Lantikan Ke Skim Perkhidmatan Sekarang", ": #{@staff.schemedt.try(:strftime, "%d/%m/%y")}"],
                 ["32. Tarikh Lantikan Ke Skim Sekarang", ": #{@staff.schemedt.try(:strftime, "%d/%m/%y")}"],
                 ["33. Tarikh Sah Perkhidmatan",": #{@staff.confirmdt.try(:strftime, "%d/%m/%y")}"],
                 ["34. Tarikh Sah Ke Jawatan Sekarang", ": #{@staff.posconfirmdate.try(:strftime, "%d/%m/%y")}"],
                 ["35. Tarikh Terkini Isytihar Harta", ": #{@staff.wealth_decleration_date.try(:strftime, "%d/%m/%y")}"],
                 ["36. Tarikh Naik Pangkat/Memangku", ": #{@staff.promotion_date.try(:strftime, "%d/%m/%y")}"],
                 ["37. Tarikh Sah Semula (Opsyen)", ": #{@staff.reconfirmation_date.try(:strftime, "%d/%m/%y")}"],
                 ["38. Tarikh Sah Ke Gred Sekarang", ": #{@staff.to_current_grade_date.try(:strftime, "%d/%m/%y")}"],
                 ["39. Gaji Permulaan", @view.currency(@staff.starting_salary.to_f)],
                 ["40. Pihak Berkuasa Melantik", ": #{(DropDown::APPOINTED.find_all{|disp, value| value == @staff.appointby }).map {|disp, value| disp}[0]}"],
                 ["41. Ketua Perkhidmatan", ": #{(DropDown::HOS.find_all{|disp, value| value == @staff.svchead }).map {|disp, value| disp}[0]}"],
                 ["42. Jenis Perkhidmatan", ": #{(DropDown::TOS.find_all{|disp, value| value == @staff.svctype }).map {|disp, value| disp}[0]}"],
                 ["43. Status Pencen", ": #{(DropDown::PENSION.find_all{|disp, value| value == @staff.pensionstat}).map {|disp, value| disp}[0]}"],
                 ["44. Tarikh Berpencen", ": #{@staff.pensiondt.try(:strftime, "%d/%m/%y")}"],
                 ["45. Tarikh Perakuan Pencen",": #{@staff.pension_confirm_date.try(:strftime, "%d/%m/%y")}"],
                 ["46. Status Pakaian Seragam", ": #{(DropDown::UNIFORM.find_all{|disp, value| value == @staff.uniformstat }).map {|disp, value| disp}[0]}"]]
            
                 table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
                   a = 0
                   b = 23
                   row(0).font_style = :bold
                   row(0).background_color = 'FFE34D'
                   while a < b do
                   row(a).borders = []
                   a += 1
                 end

                 end
                  move_down 10
            end
 
            def table_qualification
              table(qualification, :column_widths => [150, 125, 125], :cell_style => { :size => 11})  do
                a = 0
                b = 10
                row(0).font_style = :bold
                row(0).background_color = 'FFE34D'   
                row(1).height = 18   
                while a < b do
                row(a).borders = []
                a += 1
              end          
              end
              move_down 10
            end
  
            def qualification
  
            header1 = [["47. Tahap Akademik", "Kelayakan", " Institusi"],
                        ["", "", ""]]
            header1 +
            @staff.qualifications.map do |qualification|
     
              [ ": #{(DropDown::QUALIFICATION_LEVEL.find_all{|disp, value| value == qualification.level_id}).map {|disp, value| disp}[0]}", ": #{qualification.qname}", ": #{qualification.institute}" ]
 
            end
  
          end
  
          def table_loan
            table(loan, :column_widths => [80, 80, 80, 80, 80], :cell_style => { :size => 11})  do
              a = 0
              b = 10
              row(0).font_style = :bold
              row(0).background_color = 'FFE34D'   
              row(1).height = 18   
              while a < b do
              row(a).borders = []
              a += 1
            end          
            end
            move_down 10
          end

          def loan

          header1 = [["48. Loan", "No Akaun"," Tarikh Pinjaman", "Tempoh Bayaran Balik", "Ansuran bulanan"],
                      ["", "", "", "", ""]]
          header1 +
          @staff.loans.map do |loan|
   
            [ "Loan Type : #{(DropDown::LOAN_TYPE.find_all{|disp, value| value == loan.ltype }).map {|disp, value| disp}[0]}",": #{loan.accno}",
            ": #{@staff.schemedt}",": #{loan.durationmn}", " : #{loan.deductions}"]

          end

        end
  
              def table3
      
                data =[["Butiran Kewangan", ""],
                      ["49. EPF No", ": #{@staff.kwspcode}"],
                      ["50. Tax No", ": #{@staff.taxcode}"]]
            
                      table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
                        a = 0
                        b = 4
                        row(0).font_style = :bold
                        row(0).background_color = 'FFE34D'
                        while a < b do
                        row(a).borders = []
                        a += 1
                      end
                   
                      end
                  move_down 10
                   end
                   
      
            
                           def table4
                             table(waris, :column_widths => [60, 80, 70, 60, 130], :cell_style => { :size => 10})  do
                               a = 0
                               b = 10
                               row(0).font_style = :bold
                               row(0).background_color = 'FFE34D'   
                               row(1).height = 18   
                               while a < b do
                               row(a).borders = []
                               a += 1
                             end          
                             end
                             move_down 10
                           end

                           def waris

                           header1 = [["52. Waris", "Nama"," Kad No", "No Telefon", "Alamat"],
                                       ["", "", "", "", ""]]
                           header1 +
                           @staff.kins.map do |kin|
   
                             [ "Loan Type : #{(DropDown::KIN_TYPE.find_all{|disp, value| value == kin.kintype_id }).map {|disp, value| disp}[0]}",
                             ": #{kin.try(:name)}",": #{kin.mykadno}", " : #{kin.phone}", "#{kin.kinaddr}"]

                           end

                         end
  
end