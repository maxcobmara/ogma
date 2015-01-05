class AddColumnsToProgramme < ActiveRecord::Migration
  def change
    add_column :programmes, :subject_abbreviation, :string
  end
end
