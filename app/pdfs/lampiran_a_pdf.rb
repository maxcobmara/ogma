class Lampiran_aPdf < Prawn::Document 
  def initialize(asset_loan, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset_loan  = asset_loan
    @view = view
    font "Times-Roman"
    move_down 10
    text "LAMPIRAN A", :align => :right, :size => 12, :style => :bold
    move_down 20
    text "BORANG KEBENARAN MEMINJAM/MEMBAWA KELUAR", :align => :center, :size => 12, :style => :bold
    text "HARTA MODAL/INVENTORI", :align => :center, :size => 12, :style => :bold
    move_down 10
    table_details
    table_declarations
    move_down 20
    table_loaner_signatory
    move_down 20
    table_hod_signatory
    move_down 20
    stroke_horizontal_rule
    move_down 10
    table_regulations
  end
  
  def table_details
    data=[["Jenis :","#{@asset_loan.asset.try(:code_typename_serial_no)}"], ["Jenama dan Model :","#{@asset_loan.asset.try(:name_modelname)}"], ["Nama Peminjam :","#{@asset_loan.loaner}"], ["Tujuan Pinjaman :","#{@asset_loan.reasons}"], ["Tarikh dikeluarkan :","#{@asset_loan.loaned_on.try(:strftime, "%d %b %Y")}"], ["Tarikh jangka dipulangkan :","#{@asset_loan.expected_on.try(:strftime, "%d %b %Y")}"]]
     table(data, :column_widths => [200, 310], :cell_style => { :size => 11, :borders => []})  do
              a = 0
              b = 6
              column(0).font_style = :bold
              while a < b do
              a += 1
            end
    end
  end
  
  def table_declarations
    data=[["Perakuan Pegawai yang meminjam :"],["Adalah dengan ini saya mengaku akan bertanggungjawab sepenuhnya ke atas keselamatan aset yang dinyatakan di atas kepada saya. Saya juga mengambil maklum bahawa saya akan dikenakan bayaran balik sekiranya berlaku kehilangan aset tersebut yang berpunca akibat dari kecuaian saya."],[""],["Sekian, terima kasih."]]
    table(data, :column_widths => [510], :cell_style => { :size => 11, :borders => []})  do
              a = 0
              b = 4
              row(0).font_style = :bold
              row(1).font_style = :normal
              row(3).font_style = :normal
              while a < b do
              a += 1
            end
    end
  end
  
  def table_loaner_signatory
    data=[["Tandatangan Pegawai Peminjam","via icms"],["Nama","#{@asset_loan.loanofficer.try(:name)}"],["Tarikh","#{@asset_loan.approved_date.try(:strftime, "%d %b %Y")}"],[content: "Pengeluaran #{@asset_loan.is_approved? ? "Diluluskan / <strikethrough> Tidak Diluluskan </strikethrough>  " : "<strikethrough> Diluluskan </strikethrough> /  Tidak Diluluskan"}", colspan: 2, :inline_format => true]]
     table(data, :column_widths => [240, 270], :cell_style => { :size => 11, :borders => []})  do
              a = 0
              b = 4
              column(0).font_style = :bold
              column(1).font_style = :normal
              while a < b do
              a += 1
            end
    end
  end
  
  def table_hod_signatory
    data=[["Tandatangan Ketua Jabatan","#{@asset_loan.approved_date.blank? ? "Not Viewed" : "via icms"}"],["Nama", "#{@asset_loan.approved_date.blank? ? "Not Viewed" : @asset_loan.hodept.name }"],["Tarikh","#{@asset_loan.hod_date.try(:strftime, "%d %b %Y") unless @asset_loan.hod_date.blank?}"]]
    table(data, :column_widths => [240, 270], :cell_style => { :size => 11, :borders => []})  do
              a = 0
              b = 3
              column(0).font_style = :bold
              column(1).font_style = :normal
              while a < b do
              a += 1
            end
    end
  end
  
  def table_regulations
    data=[[content: "Berdasarkan para <b>16 Bab C Pekeliling Perbendaharaan Bil. 5 tahun 2007</b>, pegawai yang bertanggungjawab ke atas aset hendaklah mematuhi tatacara penyimpanan aset adalah seperti berikut:- ", colspan: 2, :inline_format => true], ["","para 16.1 – Aset Kerajaan hendaklah disimpan di tempat yang selamat dan sentiasa di bawahkawalanpegawaiyangbertanggungjawab. Arahan Keselamatan Kerajaan hendaklah sentiasa dipatuhi bagi mengelak berlakunya kerosakan atau kehilangan aset; "], ["","para 16.2 – Setiap pegawai adalah bertanggungjawab terhadap apa-apa kekurangan, kerosakan atau kehilangan aset di bawah tanggungjawabnya; dan"],["","para 16.3 – Aset yang sangat menarik atau bernilai tinggi akan terdedah kepada risiko kehilangan, maka hendaklah sentiasa di bawah kawalan yang maksima. "], ["","Para 17 – Pegawai yang gagal mematuhi peaturan di atas, boleh dikenakan tindakan termasuk surcaj dibawah Seksyen 18(c) Akta Prosedur Kewangan 1957"]]
    table(data, :column_widths => [50, 460], :cell_style => { :size => 11, :borders => []})  do
              a = 0
              b = 6
              row(0..5).font_style = :normal
              while a < b do
              a += 1
            end
    end
    
  end
  
  
end

