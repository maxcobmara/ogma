class Lesson_planPdf< Prawn::Document
  def initialize(lesson_plan, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @lesson_plan = lesson_plan
    @view = view
    font "Times-Roman"
    #table_title
    text "(Borang ini hendaklah diisi dalam 3 salinan sebelum perjalanan dilakukan)", :style => :italic, :align => :center
    move_down 5
    #table_applicant
    #table_content
    #table_transport_choice
    #table_signatory
  end
end