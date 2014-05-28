class Kewpa14Pdf < Prawn::Document
  def initialize(asset, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset = asset
    @view = view
    font "Times-Roman"
    text "KEW.PA-14", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "DAFTAR PENYELENGGARAAN HARTA MODAL", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "Sub Kategori        : #{@asset.subcategory}", :align => :left, :size => 12
    text "No Siri Pendaftaran : #{@asset.assetcode}", :align => :left, :size => 12
    move_down 10
    text "Jenis  : #{@asset.typename}", :align => :left, :size => 12
    text "Lokasi : #{@asset.try(:asset_placements).try(:location).try(:name)}", :align => :left, :size => 12
    move_down 20
    description

  end
  

  def description
   table(penem , :column_widths => [60,130, 90, 90, 50, 100 ], :cell_style => { :size => 8}) do
     row(0).font_style = :bold
     row(0).align = :center
     row(0).background_color = 'FFE34D'
   end
  end
  
  def penem
  
  header1 = [['Tarikh', "Butir-Butir Kerja", "No Kontrak /Pesanan Kerajaan dan Tarikh", "Nama Syarikat /Jabatan Yang Menyelenggara", "Kos (RM)", "Nama & Tandatangan"]]
  header1 +
  @asset.maints.map do |maint|
    [ "#{maint.created_at.strftime("%d/%m/%y")}", "#{maint.details}","#{maint.workorderno}",
      "#{maint.maintainer_id}",@view.currency(maint.maintcost.to_f), "#{maint.try(:asset).try(:staff).try(:name)}" ]
 
  end 
end
  
end