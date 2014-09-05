class AddColumnToProgramme < ActiveRecord::Migration
   def self.up
     add_column :programmes, :lecture, :integer
     add_column :programmes, :tutorial, :integer
     add_column :programmes, :practical, :integer
     add_column :programmes, :lecture_time, :integer
     add_column :programmes, :tutorial_time, :integer
     add_column :programmes, :practical_time, :integer
  end

  def self.down
     remove_column :programmes, :lecture
     remove_column :programmes, :tutorial
     remove_column :programmes, :practical
     remove_column :programmes, :lecture_time
     remove_column :programmes, :tutorial_time
     remove_column :programmes, :practical_time
  end
end
