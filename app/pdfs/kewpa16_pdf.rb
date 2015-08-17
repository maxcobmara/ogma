class Kewpa16Pdf < Prawn::Document
  def initialize(disposal, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @disposals = disposal
    @view = view
    font "Times-Roman"
    text "KEW.PA-16", :align => :right, :size => 14, :style => :bold
    move_down 20
    text "KERAJAAN MALAYSIA ", :align => :center, :size => 12
    text "PERAKUAN PELUPUSAN (PEP) ASET ALIH KERAJAAN", :align => :center, :size => 12
    move_down 10
    table1
    data
    table2
    #for test #move_down 10
    if y < 180
      start_new_page
    end
    data2
  end
  
  def table1
    data = [["Kementerian/Jabatan", ": Kementerian Kesihatan Malaysia - Kolej Sains Kesihatan Bersekutu Johor"],
             ["Alamat", ": Persiaran Kempas, Johor Baru"]]    
    table(data, :column_widths => [120, ], :cell_style => { :size => 9})  do
      row(0..1).borders = [ ]
    end
    data1 = [["No Siri Pendaftaran Aset (KEW.PA-2/PA-3)",": #{@disposals.try(:asset).try(:assetcode)}","",""],
             ["No. Kodifikasi Nasional",":","Jumlah Jarak Perjalanan(km)/ Tempoh Penggunaan(jam)", ": #{@disposals.mileage} #{@disposals.running_hours}"],
             ["Jenis, Jenama dan Model", ":#{@disposals.try(:asset).try(:typename)} #{@disposals.try(:asset).try(:name)} #{@disposals.try(:asset).try(:modelname)}","Tahap Penyampaian Perkhidmatan(%)",":"],
             ["No. Chassis/Siri Pembuat",": #{@disposals.try(:asset).try(:serialno)}","Jumlah Kos Penyelenggaraan Terdahulu", ": #{@disposal.try(:asset).try(:maints).try(:maintcost)}" ],
             ["No. Enjin",": #{@disposals.try(:asset).try(:engine_no)}","Anggaran Kos Penyelenggaraan Semasa", ": #{@view.currency(@disposals.est_repair_cost.to_f)}"],
             ["No. Pendaftaran (kenderaan)",": #{@disposals.try(:asset).try(:registration)}","Nilai Semasa", ": #{@view.currency(@disposals.current_value.to_f)}" ],
             ["Tarikh dibeli",": #{@disposals.try(:asset).try(:purchasedate).try(:strftime,"%d/%m/%y")}","Anggaran Nilai Selepas Dibaiki",": #{@view.currency(@disposals.est_value_post_repair.to_f)}"],
             ["Harga Perolehan Asal",": #{@view.currency(@disposals.asset.purchaseprice.to_f)}","Anggaran Tahan Selepas Dibaiki ",": #{@disposals.est_time_next_fail} (bulan)"]]
             
    table(data1, :column_widths => [120, 120, 150, 80], :cell_style => { :size => 9})  do
      row(0..7).borders = [ ]  
    end
    move_down 10
  end
  
  def data
    text "LAPORAN PEMERIKSAAN", :align => :left, :size => 10, :style => :bold
    move_down 10
    text "Butir-butir penambahbaikan yang perlu :-", :align => :left, :size => 10
    text "1. #{@disposals.repair1_needed} ", :align => :left, :size => 10
    text "2. #{@disposals.repair2_needed} ", :align => :left, :size => 10
    text "3. #{@disposals.repair3_needed} ", :align => :left, :size => 10
    move_down 20
    text "Disahkan bahawa aset tersebut telah diperiksa dan diperakui untuk pelupusan", :align => :left, :size => 10
    text "atas sebab-sebab berikut :-", :align => :left, :size => 10
    text "1. #{@disposals.justify1_disposal} ", :align => :left, :size => 10
    text "2. #{@disposals.justify2_disposal}", :align => :left, :size => 10
    text "3. #{@disposals.justify3_disposal}", :align => :left, :size => 10
    move_down 10
  end
  
  def table2
    data = [["<u>#{@disposals.is_checked? ? @disposals.processor.name.to_s + " via ICMS" : ""}</u>", "", "#{'_'*60}"],
           ["(Tandatangan)","","(Tandatangan)"],
           ["Nama : #{@disposals.processor.name.to_s}","","Nama : #{@disposals.verifier.name.to_s}"],
           ["Jawatan : #{@disposals.processor.positions.first.try(:name) }","","Jawatan : #{@disposals.verifier.positions.first.try(:name) }"],
           ["Tarikh :","", "Tarikh :"],
           ["Cop :","","Cop :"]]
           
    table(data, :column_widths => [160, 120, 160], :cell_style => { :size => 9,  :inline_format => :true})  do
             row(0..5).height = 18
             row(0..5).borders = [ ]
             row(1).align = :center
    end
    move_down 10
  end
      
  def data2
    pad_top(20) {text "Ruangan ini hendaklah diisi jika PEP melebihi tempoh satu (1) tahun." , :size => 10}
    move_down 10
    text "Aset telah dibuat penilaian semula dengan nilai semasa RM #{'.'*40}", :align => :left, :size => 10 
    move_down 10
        
    data = [["#{'.'*60}", ""],
              ["(Tandatangan)",""],
              ["Nama :",""],
              ["Jawatan :",""],
              ["Tarikh :",""]]
 
    table(data, :column_widths => [160,160], :cell_style => { :size => 9})  do
       row(0..4).borders = [ ]
       row(0..4).height = 18
       row(1).align = :center
    end
  end
               
end