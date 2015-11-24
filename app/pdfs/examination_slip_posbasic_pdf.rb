class Examination_slipPdf < Prawn::Document
  def initialize(resultline, view)
    super({top_margin: 20, left_margin:100, right_margin:80, page_size: 'A4', page_layout: :portrait })
    @resultline = resultline
    @view = view
    font "Helvetica"
    ### TODO - Examination TRANSCRIPT?
    #Refer: Additional file from Pn Hamidah Denan(Kebidanan / wakil Pos Basik) - Transcript ADMW.xls & Comment by En Ahmad Zahrullail (Pen Peg Perubatan)
  end
end