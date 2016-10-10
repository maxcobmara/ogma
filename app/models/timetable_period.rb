class TimetablePeriod < ActiveRecord::Base
    
  belongs_to :timetable, :foreign_key => 'timetable_id'
  
  validates_uniqueness_of :sequence, :scope => :timetable_id
      
  def timing
    #"#{start_at.strftime("%l:%M %p")}"+" -"+"#{end_at.strftime("%l:%M %p")}"
    "#{start_at.try(:strftime, "%l:%M%P")}"+"-"+"#{end_at.try(:strftime, "%l:%M%P")}"
  end 
  

  NON_CLASS=[
    # display  #stored in db
    [ 'Senaman Pagi', '1'],
    [ 'Sarapan/Perbarisan Pagi', '2'],
    [ 'Kudapan', '3' ],
    [ 'Makan Tengahari/Solat Zohor', '4'],
    [ 'Latihan Fizikal/Sukan', '5'],
    [ 'Makan Malam/Solat', '6'],
    [ 'Rehat/Pipe Down', '7']
  ]
  
  #Latihan Fizikal/Sukan (Jurulatih Fizikal)
  #MAKAN MALAM / SOLAT MAGRIB / SOLAT ISYAK / LAWATAN MALAM (PEGAWAI BERTUGAS HARIAN)
  #REHAT / PIPE DOWN (PEGAWAI BERTUGAS HARIAN)
  
end

# == Schema Information
#
# Table name: timetable_periods
#
#  created_at   :datetime
#  day_name     :integer
#  end_at       :time
#  id           :integer          not null, primary key
#  is_break     :boolean
#  sequence     :integer
#  start_at     :time
#  timetable_id :integer
#  updated_at   :datetime
#
