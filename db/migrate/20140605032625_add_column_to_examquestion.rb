class AddColumnToExamquestion < ActiveRecord::Migration
  def self.up
    add_column :examquestions, :diagram_caption, :string
  end

  def self.down
    remove_column :examquestions, :diagram_caption
  end
end
