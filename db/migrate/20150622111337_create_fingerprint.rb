class CreateFingerprint < ActiveRecord::Migration
  def change
    create_table :fingerprints do |t|
      t.integer :thumb_id
      t.date :fdate
      t.integer :ftype
      t.string :reason
      t.integer :approved_by
      t.boolean :is_approved
      t.date :approved_on
      t.integer :status
    end
  end
end
