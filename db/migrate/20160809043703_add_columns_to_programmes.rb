class AddColumnsToProgrammes < ActiveRecord::Migration
  def change
    add_column :programmes, :durationtype, :string
    add_column :programmes, :lecture_d, :time
    add_column :programmes, :tutorial_d, :time
    add_column :programmes, :practical_d, :time
  end
end
