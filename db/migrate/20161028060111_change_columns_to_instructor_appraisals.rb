class ChangeColumnsToInstructorAppraisals < ActiveRecord::Migration
  def self.up
     remove_column :instructor_appraisals, :q1, :integer
     remove_column :instructor_appraisals, :q2, :integer
     remove_column :instructor_appraisals, :q3, :integer
     remove_column :instructor_appraisals, :q4, :integer
     remove_column :instructor_appraisals, :q5, :integer
     remove_column :instructor_appraisals, :q6, :integer
     remove_column :instructor_appraisals, :q7, :integer
     remove_column :instructor_appraisals, :q8, :integer
     remove_column :instructor_appraisals, :q9, :integer
     remove_column :instructor_appraisals, :q10, :integer

     remove_column :instructor_appraisals, :q11, :integer
     remove_column :instructor_appraisals, :q12, :integer
     remove_column :instructor_appraisals, :q13, :integer
     remove_column :instructor_appraisals, :q14, :integer
     remove_column :instructor_appraisals, :q15, :integer
     remove_column :instructor_appraisals, :q16, :integer
     remove_column :instructor_appraisals, :q17, :integer
     remove_column :instructor_appraisals, :q18, :integer
     remove_column :instructor_appraisals, :q19, :integer
     remove_column :instructor_appraisals, :q20, :integer

     remove_column :instructor_appraisals, :q21, :integer
     remove_column :instructor_appraisals, :q22, :integer
     remove_column :instructor_appraisals, :q23, :integer
     remove_column :instructor_appraisals, :q24, :integer
     remove_column :instructor_appraisals, :q25, :integer
     remove_column :instructor_appraisals, :q26, :integer
     remove_column :instructor_appraisals, :q27, :integer
     remove_column :instructor_appraisals, :q28, :integer
     remove_column :instructor_appraisals, :q29, :integer
     remove_column :instructor_appraisals, :q30, :integer

     remove_column :instructor_appraisals, :q31, :integer
     remove_column :instructor_appraisals, :q32, :integer
     remove_column :instructor_appraisals, :q33, :integer
     remove_column :instructor_appraisals, :q34, :integer
     remove_column :instructor_appraisals, :q35, :integer
     remove_column :instructor_appraisals, :q36, :integer
     remove_column :instructor_appraisals, :q37, :integer
     remove_column :instructor_appraisals, :q38, :integer
     remove_column :instructor_appraisals, :q39, :integer
     remove_column :instructor_appraisals, :q40, :integer
         
     remove_column :instructor_appraisals, :q41, :integer
     remove_column :instructor_appraisals, :q42, :integer
     remove_column :instructor_appraisals, :q43, :integer
     remove_column :instructor_appraisals, :q44, :integer
     remove_column :instructor_appraisals, :q45, :integer
     remove_column :instructor_appraisals, :q46, :integer
     remove_column :instructor_appraisals, :q47, :integer
     remove_column :instructor_appraisals, :q48, :integer
  end
  
  def self.down
     add_column :instructor_appraisals, :q1, :integer
     add_column :instructor_appraisals, :q2, :integer
     add_column :instructor_appraisals, :q3, :integer
     add_column :instructor_appraisals, :q4, :integer
     add_column :instructor_appraisals, :q5, :integer
     add_column :instructor_appraisals, :q6, :integer
     add_column :instructor_appraisals, :q7, :integer
     add_column :instructor_appraisals, :q8, :integer
     add_column :instructor_appraisals, :q9, :integer
     add_column :instructor_appraisals, :q10, :integer

     add_column :instructor_appraisals, :q11, :integer
     add_column :instructor_appraisals, :q12, :integer
     add_column :instructor_appraisals, :q13, :integer
     add_column :instructor_appraisals, :q14, :integer
     add_column :instructor_appraisals, :q15, :integer
     add_column :instructor_appraisals, :q16, :integer
     add_column :instructor_appraisals, :q17, :integer
     add_column :instructor_appraisals, :q18, :integer
     add_column :instructor_appraisals, :q19, :integer
     add_column :instructor_appraisals, :q20, :integer
 
     add_column :instructor_appraisals, :q21, :integer
     add_column :instructor_appraisals, :q22, :integer
     add_column :instructor_appraisals, :q23, :integer
     add_column :instructor_appraisals, :q24, :integer
     add_column :instructor_appraisals, :q25, :integer
     add_column :instructor_appraisals, :q26, :integer
     add_column :instructor_appraisals, :q27, :integer
     add_column :instructor_appraisals, :q28, :integer
     add_column :instructor_appraisals, :q29, :integer
     add_column :instructor_appraisals, :q30, :integer
 
     add_column :instructor_appraisals, :q31, :integer
     add_column :instructor_appraisals, :q32, :integer
     add_column :instructor_appraisals, :q33, :integer
     add_column :instructor_appraisals, :q34, :integer
     add_column :instructor_appraisals, :q35, :integer
     add_column :instructor_appraisals, :q36, :integer
     add_column :instructor_appraisals, :q37, :integer
     add_column :instructor_appraisals, :q38, :integer
     add_column :instructor_appraisals, :q39, :integer
     add_column :instructor_appraisals, :q40, :integer
 
     add_column :instructor_appraisals, :q41, :integer
     add_column :instructor_appraisals, :q42, :integer
     add_column :instructor_appraisals, :q43, :integer
     add_column :instructor_appraisals, :q44, :integer
     add_column :instructor_appraisals, :q45, :integer
     add_column :instructor_appraisals, :q46, :integer
     add_column :instructor_appraisals, :q47, :integer
     add_column :instructor_appraisals, :q48, :integer   
  end
end
