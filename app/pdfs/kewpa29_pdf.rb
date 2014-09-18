class Kewpa29Pdf < Prawn::Document
  def initialize(asset_loss, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset_loss = asset_loss
    @view = view
    font "Times-Roman"
    text "KEW.PA-29", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "No. Rujukan Fail:", :align => :left, :size => 14, :indent_paragraphs => 300
    text "Tarikh:", :align => :left, :size => 14, :indent_paragraphs => 300
    move_down 20
    text "Kepada :", :align => :left, :size => 14
    move_down 10
    text " #{"."*40}", :align => :left, :size => 14
    move_down 5
    text " #{"."*40} ", :align => :left, :size => 14
    move_down 5
    text " (Nama dan Jawatan)", :align => :left, :size => 14
     move_down 20
    text " PELANTIKAN JAWATANKUASA PENYIASAT KEHILANGAN ASET ALIH KERAJAAN", :align => :left, :size => 14, :style => :bold
    move_down 30
    text " Saya sebagai Pegawai Pengawal dengan ini melantik tuan/puan sebagai
    Pengerusi/Ahli Jawatankuasa Penyiasat untuk menyiasat kehilangan  ...
    #{@asset_loss.try(:asset).try(:name)} #{@asset_loss.try(:asset).try(:modelname)}.. (nama aset) di  #{"."*60} (Kementerian/Jabatan/PTJ)
    mulai dari tarikh surat ini. (No. Rujukan Laporan Awal  #{'.'*40} ) ", :align => :left, :size => 14
    move_down 30
    text "2.    Tuan/Puan adalah diberi kuasa untuk menjalankan siasatan dengan mendapatkan
     maklumat mengenai kes kehilangan tersebut daripada mana-mana pegawai yang berkenaan.
     Bersama-sama ini disertakan Laporan Awal dan senarai Tugas Jawatankuasa Penyiasat sebagai panduan.", :align => :left, :size => 14
    move_down 30
    text "3.    Laporan siasatan hendaklah menggunakan Laporan Akhir (KEW.PA-30) seperti
    yang dilampirkan. Laporan ini mestilah dikembalikan sebelum #{'.'*40} (tarikh).", :align => :left, :size => 14
    move_down 80
    
    text "Tandatangan           :	", :align => :left, :size => 14
    text "Nama Pegawai Pengawal :	", :align => :left, :size => 14
    text "Kementerian/Jabatan   :	", :align => :left, :size => 14
    move_down 40
    text "s.k  Ketua Setiausaha Perbendaharaan Malaysia	", :align => :left, :size => 14
    
   
  end
  
  
end