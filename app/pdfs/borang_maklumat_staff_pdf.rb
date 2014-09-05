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
    table3
    table4
    
  end
  
    def table1
      
      data =[["Butiran Peribadi", ""]
            ["1. MyKad No", ": #{@staff.icno}"],
            ["2. Nama", ": #{@staff.name}"],
            ["3. Staff Code", ": #{@staff.code}"],
            ["4. No Fail Peribadi", ": #{@staff.fileno}"],
            ["5. Jawatan",": #{@staff.position.name}"],
            ["6. Email", ": #{@staff.coemail}"],
            ["7. Tarikh Lahir", ": #{@staff.cobirthdt}"],
            ["8. No Surat Beranak", ": #{@staff.birthcertno}"],
            ["9. Umur",": #{@staff.age}"],
            ["10. Jenis Darah", ": #{@staff.bloodtype}"],
            ["11. Jantina", ": #{@staff.gender}"],
            ["12. Telefon", ": #{@staff.cooftelno} , #{@staff.cooftelext} , #{@staff.phonecell}", ],
            ["13. Alamat", ": #{@staff.addr}"],
            ["14. Poskod", ": #{@staff.poskod_id}"],
            ["15. Taraf Perkahwinan",": #{@staff.mrtlstatuscd}"],
            ["16. Negeri Dilahirkan", ": #{@staff.statecd}"],
            ["17. Bangsa", ": #{@staff.race}"],
            ["18. Agama", ": #{@staff.religion}"],
            ["19. Kewarganegaraan", ": #{@staff.country_cd}"],
            ["20. Kelas Pengankutan", ": #{@staff.transportclass_id}" ],
            ["21. No Cukai Pendapatan",": #{@staff.taxcode}"],
            ["22. No Akaun Bank", ": #{@staff.bankaccno}"],
            ["23. Nama Bank", ": #{@staff.my_bank}"],
            ["24. Jenis Akaun",": #{@staff.bankacctype}"]]
            
            table(data, :column_widths => [150, 180], :cell_style => { :size => 11}, :row_borders => [])  do
              row(0).font_style = :bold
              row(0).background_color = 'FFE34D'

            end
         end
  
         def table2
      
           data =[[" Butiran Pekerjaan", ""],
                 ["26. Gred Jawatan", ": #{@staff.staffgrade.name_and_group}"],
                 ["27. Jawatan", ": #{@staff.position.name}"],
                 ["28. Melapor Kepada", ": #{@staff.render_reports_to}"],
                 ["29. Status Pekerjaan",": #{@staff.employstatus}"],
                 ["30. Status Lantikan", ": #{@staff.appointdt}"],
                 ["31. Tarikh Lantikan Ke Skim Perkhidmatan Sekarang", ": #{@staff.schemedt}"],
                 ["32. Tarikh Lantikan Ke Skim Sekarang", ": #{@staff.schemedt}"],
                 ["33. Tarikh Sah Perkhidmatan",": #{@staff.confirmdt}"],
                 ["34. Tarikh Sah Ke Jawatan Sekarang", ": #{@staff.posconfirmdate}"],
                 ["35. Tarikh Terkini Isytihar Harta", ": #{@staff.wealth_decleration_date}"],
                 ["36. Tarikh Naik Pangkat/Memangku", ": #{@staff.promotion_date}"],
                 ["37. Tarikh Sah Semula (Opsyen)", ": #{@staff.reconfirmation_date}"],
                 ["38. Tarikh Sah Ke Gred Sekarang", ": #{@staff.to_current_grade_date}"],
                 ["39. Gaji Permulaan",": #{@staff.starting_salary}"],
                 ["40. Pihak Berkuasa Melantik", ": #{@staff.appointby}"],
                 ["41. Ketua Perkhidmatan", ": #{@staff.svchead}"],
                 ["42. Jenis Perkhidmatan", ": #{@staff.svctype}"],
                 ["43. Status Pencen", ": #{@staff.pensionstat}"],
                 ["44. Tarikh Berpencen", ": #{@staff.pensiondt}"],
                 ["45. Tarikh Perakuan Pencen",": #{@staff.pension_confirm_date}"],
                 ["46. Status Pakaian Seragam", ": #{@staff.uniformstat}"]]
            
                 table(data, :column_widths => [150, 180], :cell_style => { :size => 11}, :row_borders => [])  do
                   row(0).font_style = :bold
                   row(0).background_color = 'FFE34D'

                 end
              end
  
              def table3
      
                data =[["Butiran Kewangan", ""],
                      ["49. EPF No", ": #{@staff.kwspcode}"],
                      ["50. Tax No", ": #{@staff.taxcode}"]]
            
                      table(data, :column_widths => [150, 180], :cell_style => { :size => 11}, :row_borders => [])  do
                        row(0).font_style = :bold
                        row(0).background_color = 'FFE34D'

                      end
                   end
                   
                   def table4
      
                     data =[["Waris Terdekat", ""],
                           ["52. Maklumat Keluarga", ": #{@staff.kins}"]]
      
            
                           table(data, :column_widths => [150, 180], :cell_style => { :size => 11}, :row_borders => [])  do
                             row(0).font_style = :bold
                             row(0).background_color = 'FFE34D'

                           end
                        end
  
end