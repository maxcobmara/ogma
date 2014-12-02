class ClaimprintPdf < Prawn::Document
  def initialize(travel_claim, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @travel_claim = travel_claim
    @view = view
    
    font "Times-Roman"
    text "LAMPIRAN A", :align => :right, :size => 12, :style => :bold
    move_down 15
    text "KENYATAAN TUNTUTAN PERJALANAN DALAM NEGERI", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "BAGI BULAN :  #{@travel_claim.claim_month.strftime("%b").upcase}        TAHUN: #{@travel_claim.claim_month.strftime("%Y")}", :align => :center, :size => 12, :style => :bold
    move_down 10
    table1
    elaun
    awam
    makan
    hotel
    pelbagai
    pengakuan
    pengesahan
    pendahuluan

   
  end
  
  def table1
    data1 = [[" ", "MAKLUMAT PEGAWAI", ""],
             ["NAMA", " #{@travel_claim.staff.name} ", ""],
             ["NO KAD PENGENALAN", "#{@travel_claim.staff.formatted_mykad}", ""],
             ["GRED/KATEGORI/KUMPULAN", "#{@travel_claim.staff.staffgrade.name}", ""],
             ["JAWATAN", "#{@travel_claim.staff.try(:position).try(:name)} ", ""],
             ["", "GAJI", @view.currency(@travel_claim.staff.starting_salary.to_f)],
             ["PENDAPATAN (RM)", "ELAUN-ELAUN", " "],
             ["", "JUMLAH",""],
             ["","JENIS MODEL",""],
             ["KENDERAAN", "NO PENDAFTARAN",""],
             ["","KUASA (C.C)", " "],
             ["","KELAS TUNTUTAN","#{@travel_claim.staff.transportclass_id} "]]
             
             table(data1, :column_widths => [180, 180,180], :cell_style => { :size => 10}) do
               row(0).background_color = 'FFE34D'
               self.width = 540
               row(0).align = :center
               row(0).column(0).borders = [:top, :bottom, :left]
               row(0).column(1).borders = [:top, :bottom]
               row(0).column(2).borders = [:top, :bottom, :right]
               row(1).column(1).borders = [:top, :bottom, :left]
               row(1).column(2).borders = [:top, :bottom, :right]
               row(2).column(1).borders = [:top, :bottom, :left]
               row(2).column(2).borders = [:top, :bottom, :right]
               row(3).column(1).borders = [:top, :bottom, :left]
               row(3).column(2).borders = [:top, :bottom, :right]
               row(4).column(1).borders = [:top, :bottom, :left]
               row(4).column(2).borders = [:top, :bottom, :right]
               row(5).column(0).borders = [:top,:right, :left]
               row(6).column(0).borders = [:right, :left]
               row(6).column(2).borders = [:right, :left, :top, :bottom]
               row(7).column(0).borders = [ :bottom, :right, :left]
               row(8).column(0).borders = [:top,:right, :left]
               row(9).column(0).borders = [:right, :left]
               row(10).column(0).borders = [:right, :left]
               row(11).column(0).borders = [ :bottom, :right, :left]

             end
             
             data2 = [["ALAMAT PEJABAT", "Kolej Sains Kesihatan Bersekutu
                      Lot 8173, Jalan Pesiaran Kempas Baru
                       81200 Johor Bahru, Johor" ],
                      ["ALAMAT RUMAH", "#{@travel_claim.staff.addr}"],
                      ["ALAMAT PENGINAPAN", ""],
                      ["NO GAJI", ""],
                      ["NO AKAUN", "#{@travel_claim.staff.bankaccno}"],
                      ["NAMA BANK", "#{@travel_claim.staff.bank}"],
                      ["EMAIL", " #{@travel_claim.staff.coemail}"],
                      ["NO TELEFON BIMBIT","#{@travel_claim.staff.phonecell}"]]
             
                      table(data2, :column_widths => [180, 360], :cell_style => { :size => 10}) do
                      self.width = 540
                      end
             



end

  def elaun
    start_new_page
    data1 = [["TUNTUTAN ELAUN PERJALANAN KENDERAAN" ],
             ["Bagi"]]
    
             table(data1, :column_widths => [540], :cell_style => { :size => 10}) do
               self.width = 540
               row(0).background_color = 'D8D8D8'
               row(0).align = :center
             end
    
             data2 = [["", "500 km pertama", "#{@travel_claim.km500}", "km x", "#{@travel_claim.sen_per_km500}","sen/km :" ,  @view.currency(@travel_claim.value_km500.to_f)],
                      ["", "501 km - 1,000 km", "#{@travel_claim.km1000}", "km x", "#{@travel_claim.sen_per_km1000}","sen/km :" , @view.currency(@travel_claim.value_km1000.to_f)],
                      ["", "1,001 km - 1,700 km", "#{@travel_claim.km1700}", "km x", "#{@travel_claim.sen_per_km1700}","sen/km :" , @view.currency(@travel_claim.value_km1700.to_f)],
                       ["", "1,701 km dan seterusnya", "#{@travel_claim.kmmo}", "km x", "#{@travel_claim.sen_per_kmmo}","sen/km :" , @view.currency(@travel_claim.value_kmmo.to_f)],
                        ["", " ", "", " ", " ","Jumlah:" , @view.currency(@travel_claim.value_km.to_f)]]
                      
             
                      table(data2, :column_widths => [40,190, 60, 50, 50, 70 ,80 ], :cell_style => { :size => 10}) do
                      self.width = 540
                      row(4).column(0).borders = [ :bottom, :left]
                      row(4).column(1).borders = [ :bottom]
                      row(4).column(2).borders = [ :bottom]
                      row(4).column(3).borders = [ :bottom]
                      row(4).column(4).borders = [ :bottom]

                      end
  move_down 10
  end
  
  def awam
    
    data = [[""," TUNTUTAN TAMBANG PENGANGKUTAN AWAM", ""],
            ["Teksi", "[Resit : #{@travel_claim.taxi_receipts}] : ", @view.currency(@travel_claim.taxi_receipts_total.to_f)],
            ["Bas", "[Resit : #{@travel_claim.bus_receipts}] :", @view.currency(@travel_claim.bus_receipts_total.to_f)],
            ["Kereta Api", "[Resit : #{@travel_claim.train_receipts}] :",@view.currency(@travel_claim.train_receipts_total.to_f)],
            ["Feri", "[Resit : #{@travel_claim.ferry_receipts}] :", @view.currency(@travel_claim.ferry_receipts_total.to_f)],
            ["Kapal Terbang", "[Resit : #{@travel_claim.plane_receipts}] :", @view.currency(@travel_claim.plane_receipts_total.to_f)],
            [" ", "JUMLAH :", @view.currency(@travel_claim.public_transport_totals.to_f)]]
            
            table(data, :column_widths => [170, 270, 100], :cell_style => { :size => 10}) do
              row(0).background_color = 'FFE34D'
              self.width = 540
              row(6).align = :right
              row(0).column(0).borders = [ :bottom, :top, :left]
              row(0).column(1).borders = [ :bottom, :top]
              row(0).column(2).borders = [ :bottom, :top, :right]
              row(1).column(0).borders = [ :top, :left]
              row(1).column(1).borders = [ ]
              row(1).column(2).borders = [ :right]
              row(2).column(0).borders = [ :left]
              row(2).column(1).borders = [ ]
              row(2).column(2).borders = [ :right]
              row(3).column(0).borders = [ :left]
              row(3).column(1).borders = [ ]
              row(3).column(2).borders = [ :right]
              row(4).column(0).borders = [ :left]
              row(4).column(1).borders = [ ]
              row(4).column(2).borders = [ :right]
              row(5).column(0).borders = [ :left]
              row(5).column(1).borders = [ ]
              row(5).column(2).borders = [ :right]
              row(6).column(0).borders = [ :left,  :bottom]
              row(6).column(1).borders = [ :bottom ]
              row(6).column(2).borders = [  :bottom, :right]
            end
            move_down 10
  end
  
  def makan
    
    data = [[""," TUNTUTAN ELAUN MAKAN/ELAUN HARIAN", ""],
            ["2 X	Elaun Harian sebanyak", "", ""],
            [" ", "JUMLAH :", ""]]
            
            table(data, :column_widths => [170, 270, 100], :cell_style => { :size => 10}) do
              row(0).background_color = 'FFE34D'
              self.width = 540
              row(2).align = :right
              row(0).column(0).borders = [ :bottom, :top, :left]
              row(0).column(1).borders = [ :bottom, :top]
              row(0).column(2).borders = [ :bottom, :top, :right]
              row(1).column(0).borders = [ :top, :left]
              row(1).column(1).borders = [ ]
              row(1).column(2).borders = [ :right]
              row(2).column(0).borders = [ :left,  :bottom]
              row(2).column(1).borders = [ :bottom ]
              row(2).column(2).borders = [  :bottom, :right]
            end
            move_down 10
  end
  
  def hotel
    
    data = [[""," TUNTUTAN BAYARAN SEWA HOTEL(BSH) / ELAUN LOJING", ""],
            [" ", "JUMLAH :", ""]]
            
            table(data, :column_widths => [140, 300, 100],  :cell_style => { :size => 10}) do
              row(0).background_color = 'FFE34D'
              self.width = 540
              row(1).align = :center
              row(0).column(0).borders = [ :bottom, :top, :left]
              row(0).column(1).borders = [ :bottom, :top]
              row(0).column(2).borders = [ :bottom, :top, :right]
              row(1).column(0).borders = [ :left,  :bottom]
              row(1).column(1).borders = [ :bottom ]
              row(1).column(2).borders = [  :bottom, :right]
            end
            move_down 10
  end
  
  def pelbagai
    
    data = [[""," TUNTUTAN PELBAGAI", ""],
            ["Tol", "[Resit : #{@travel_claim.toll_receipts} ] :", @view.currency(@travel_claim.toll_receipts_total)],
            ["Tempat Letak Kereta", "[Resit : #{@travel_claim.parking_receipts} ] :", @view.currency(@travel_claim.parking_receipts_total)],
            ["Dobi", "[Resit : #{@travel_claim.laundry_receipts} ] :", @view.currency(@travel_claim.laundry_receipts_total.to_f)],
            ["Pos", "[Resit : #{@travel_claim.pos_receipts } ] :", @view.currency(@travel_claim.pos_receipts_total.to_f)],
            ["Telefon, Teleks, Faks", "[Resit : #{@travel_claim.comms_receipts} ] :", @view.currency(@travel_claim.comms_receipts_total.to_f)],
            ["Kerugian pertukaran matawang asing (@ 3%) [Bagi Singapura, Selatan Thailand, Kalimantan dan Brunei Darussalam sahaja]", "", @view.currency(@travel_claim.exchange_loss_totals.to_f)],
            [" ", "JUMLAH :", @view.currency(@travel_claim.other_claims_total.to_f)],
            [" ", "JUMLAH BESAR :", @view.currency(@travel_claim.total_claims.to_f)]]
            
            table(data, :column_widths => [170, 270, 100], :cell_style => { :size => 10}) do
              row(0).background_color = 'FFE34D'
              self.width = 540
              row(7).align = :right
              row(8).align = :right
              row(0).column(0).borders = [ :bottom, :top, :left]
              row(0).column(1).borders = [ :bottom, :top]
              row(0).column(2).borders = [ :bottom, :top, :right]
              row(1).column(0).borders = [  :left]
              row(1).column(1).borders = [ ]
              row(1).column(2).borders = [ :right]
              row(2).column(0).borders = [  :left]
              row(2).column(1).borders = [ ]
              row(2).column(2).borders = [ :right]
              row(3).column(0).borders = [ :left]
              row(3).column(1).borders = [ ]
              row(3).column(2).borders = [ :right]
              row(4).column(0).borders = [ :left]
              row(4).column(1).borders = [ ]
              row(4).column(2).borders = [ :right]
              row(5).column(0).borders = [ :left]
              row(5).column(1).borders = [ ]
              row(5).column(2).borders = [ :right]
              row(6).column(0).borders = [ :left]
              row(6).column(1).borders = [ ]
              row(6).column(2).borders = [ :right]
              row(7).column(0).borders = [ :left]
              row(7).column(1).borders = [ ]
              row(7).column(2).borders = [ :right]
              row(8).column(0).borders = [ :left,  :bottom]
              row(8).column(1).borders = [ :bottom ]
              row(8).column(2).borders = [  :bottom, :right]
              
            end
            move_down 10
  end
  
  def pengakuan
    start_new_page
    
    data = [[" PENGAKUAN"],
            ["Saya mengaku bahawa:"],
            ["(a)	Perjalanan pada tarikh-tarikh tersebut adalah benar dan telah dibuat atas urusan rasmi;"],
            ["(b) Tuntutan ini dubuat mengikut kadar dan syarat seperti yang dinyatakan dibawah peraturan-peraturan bagi pegawai bertugas rasmi dan/atau pengawai berkrusus yang berkuatkuasa semasa;"],
            ["(c) Perbelanjaan yang bertanda (*) berjumlah sebanyak RM #{@travel_claim.total_claims} telah sebenarnya dilakukan dan dibayar oleh saya ;"],
            ["(d) Panggilan telefon sebanyak RM #{@travel_claim.comms_receipts_total}  dibuat atas urusan rasmi; dan"],
            ["(e) Butir-butir seperti yang dinyatakan di atas adalah benar dan saya bertanggungjawab terhadapnya"],
            ["Tarikh  #{@travel_claim.submitted_on.strftime("%d-%m-%Y")}"],
            ["#{@travel_claim.staff.name}  "],
            [" #{@travel_claim.staff.positions.name} "]]
            
            table(data, :column_widths => [540], :cell_style => { :size => 10}) do
              row(0).background_color = 'FFE34D'
              self.width = 540
              row(0).align = :center
              row(8).align = :right
              row(9).align = :right
              row(1).column(0).borders = [  :left, :right]
              row(2).column(0).borders = [  :left, :right]
              row(3).column(0).borders = [  :left, :right]
              row(4).column(0).borders = [  :left, :right]
              row(5).column(0).borders = [  :left, :right]
              row(6).column(0).borders = [  :left, :right]
              row(7).column(0).borders = [  :left, :right]
              row(8).column(0).borders = [  :left, :right]
              row(9).column(0).borders = [  :left, :right, :bottom]

            end
            move_down 10
  end
  
  def pengesahan
    
    data = [[" PENGESAHAN"],
            ["Adalah disahkan bahawa perjalanan tersebut adalah atas urusan rasmi"],
            ["Tarikh: #{@travel_claim.approved_on}"],
            ["Nama: #{@travel_claim.approver.name unless  @travel_claim.approver.blank? }"],
            ["Jawatan: #{@travel_claim.approver.try(:position).try(:name)}"]]
            
            table(data, :column_widths => [540], :cell_style => { :size => 10})  do
              row(0).background_color = 'FFE34D'
              self.width = 540
              row(0).align = :center
              row(1).column(0).borders = [  :left, :right]
              row(2).column(0).borders = [  :left, :right]
              row(3).column(0).borders = [  :left, :right]
              row(4).column(0).borders = [  :left, :right, :bottom]
            end
            move_down 10
  end
  
  def pendahuluan
    
    data = [[" PENDAHULUAN DIRI (jika ada)", " "],
            ["Pendahuluan Diri diberi ",  @view.currency(@travel_claim.advance.to_f)],
            ["Tolak: Tuntutan sekarang ", @view.currency(@travel_claim.total_claims.to_f)],
            ["Baki dituntut/Baki dibayar balik ",  @view.currency(@travel_claim.to_be_paid.to_f)]]
            
            table(data, :column_widths => [340, 200], :cell_style => { :size => 10})  do
              row(0).background_color = 'FFE34D'
              self.width = 540
              row(0).align = :right
              row(1).column(1).align = :right
              row(2).column(1).align = :right
              row(3).column(1).align = :right
              row(0).column(0).borders = [ :left, :top, :bottom]
              row(0).column(1).borders = [ :right, :top, :bottom]
              row(1).column(0).borders = [ :left]
              row(1).column(1).borders = [ :right]
              row(2).column(0).borders = [ :left]
              row(2).column(1).borders = [ :right]
              row(3).column(0).borders = [ :left, :bottom]
              row(3).column(1).borders = [ :right, :bottom]
            end
            move_down 10
  end
  
end