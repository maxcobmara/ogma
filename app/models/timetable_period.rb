class TimetablePeriod < ActiveRecord::Base
    
  belongs_to :timetable, :foreign_key => 'timetable_id'
  belongs_to :college
  
  validates_uniqueness_of :sequence, :scope => :timetable_id
      
  def timing
    #"#{start_at.strftime("%l:%M %p")}"+" -"+"#{end_at.strftime("%l:%M %p")}"
    "#{start_at.try(:strftime, "%l:%M%P")}"+"-"+"#{end_at.try(:strftime, "%l:%M%P")}"
  end 
  
  def timing_24hrs
    "#{start_at.try(:strftime, '%H:%M')} - #{end_at.try(:strftime, '%H:%M')}"
  end
  
  def render_no_class
    (TimetablePeriod::NON_CLASS_REV.find_all{|disp, value| value == non_class}).map{|disp, value| disp}[0]
  end
  

  NON_CLASS=[
    # display  #stored in db
    [ 'Senaman Pagi', 1],
    [ 'Sarapan / Perbarisan Pagi', 2],
    [ 'Kudapan', 3 ],
    [ 'Makan Tengahari / Solat Zohor', 4],
    [ 'Latihan Fizikal / Sukan', 5],
    [ 'Makan Malam / Solat', 6],
    [ 'Rehat / Pipe Down', 7],
    [ 'Rehat', 8]
  ]

  #Latihan Fizikal/Sukan (Jurulatih Fizikal)
  #MAKAN MALAM / SOLAT MAGRIB / SOLAT ISYAK / LAWATAN MALAM (PEGAWAI BERTUGAS HARIAN)
  #REHAT / PIPE DOWN (PEGAWAI BERTUGAS HARIAN)
  
  NON_CLASS_REV=[
      #display  #stored in db
      [ "SOLAT SUBUH BERJEMAAH DI MASJID", 1 ],
      [ "EMA", 2 ],
      [ "PERSONAL ADMIN", 3 ],
      [ "SARAPAN PAGI", 4 ],
      [ "EMA", 5 ],
      [ "DIVISIONAL OFFICER PERIOD", 6 ],
      [ "KUDAPAN", 7 ],
      [ "MAKAN TENGAHARI / SOLAT ZOHOR", 8 ],
      [ "MINUM PETANG / SOLAT ASAR", 9 ],
      [ "MAKAN MALAM / SOLAT MAGHRIB & ISYAK", 10],
      [ "PIPE DOWN", 11]
    ]
  
  #Related rules for AMSAS 
  #- if EMA==2 --> start from Monday - alternate, this field/cell EMA vs ''.
  #Either EMA==2 or EMA==5, for weekends (Saturday & Sunday) --> this field/cell should become 'KULIAH SUBUH' field
  
  
  DAY_CHOICE = [
         #  Displayed       stored in db
         [ "Sun-Wed", 1 ],
         [ "Thursday", 2 ]
    ]
  DAY_CHOICE2 = [
         #  Displayed       stored in db
         [ "Mon-Thurs", 1 ],
         [ "Friday", 2 ]
    ]
  
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
