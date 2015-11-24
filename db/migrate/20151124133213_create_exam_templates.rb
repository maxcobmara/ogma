class CreateExamTemplates < ActiveRecord::Migration
  def change
    create_table :exam_templates do |t|
      t.string, :name
      t.integer, :created_by
      t.text, :data
      t.date :deleted_at

      t.timestamps
    end
  end
end
