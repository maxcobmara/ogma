class AddColumnsCollegeFeatures < ActiveRecord::Migration
  def change
    add_column :academic_sessions, :college_id, :integer
    add_column :academic_sessions, :data, :string

    add_column :accessions, :college_id, :integer
    add_column :accessions, :data, :string

    add_column :address_books, :college_id, :integer
    add_column :address_books, :data, :string

    add_column :answerchoices, :college_id, :integer
    add_column :answerchoices, :data, :string

    add_column :asset_defects, :college_id, :integer
    add_column :asset_defects, :data, :string

    add_column :asset_disposals, :college_id, :integer
    add_column :asset_disposals, :data, :string

    add_column :asset_loans, :college_id, :integer
    add_column :asset_loans, :data, :string

    add_column :asset_losses, :college_id, :integer
    add_column :asset_losses, :data, :string

    add_column :asset_placements, :college_id, :integer
    add_column :asset_placements, :data, :string

    add_column :assetcategories, :college_id, :integer
    add_column :assetcategories, :data, :string

    add_column :assets, :college_id, :integer
    add_column :assets, :data, :string

    add_column :assetsearches, :college_id, :integer
    add_column :assetsearches, :data, :string

    add_column :attachment_uploaders, :college_id, :integer
    add_column :attachment_uploaders, :data, :string
  
    add_column :bankaccounts, :college_id, :integer
    add_column :bankaccounts, :data, :string

    add_column :banks, :college_id, :integer
    add_column :banks, :data, :string
  
    add_column :books, :college_id, :integer
    add_column :books, :data, :string
  
    add_column :booksearches, :college_id, :integer
    add_column :booksearches, :data, :string

    add_column :booleananswers, :college_id, :integer
    add_column :booleananswers, :data, :string

    add_column :booleanchoices, :college_id, :integer
    add_column :booleanchoices, :data, :string

    add_column :bulletins, :college_id, :integer
    add_column :bulletins, :data, :string

    add_column :circulations, :college_id, :integer
    add_column :circulations, :data, :string

    add_column :cofiles, :college_id, :integer
    add_column :cofiles, :data, :string

    add_column :courseevaluations, :college_id, :integer
    add_column :courseevaluations, :data, :string

    add_column :curriculumsearches, :college_id, :integer
    add_column :curriculumsearches, :data, :string

    add_column :documents, :college_id, :integer
    add_column :documents, :data, :string

    add_column :documents_staffs, :college_id, :integer
    add_column :documents_staffs, :data, :string

    add_column :documentsearches, :college_id, :integer
    add_column :documentsearches, :data, :string

    add_column :employgrades, :college_id, :integer
    add_column :employgrades, :data, :string

    add_column :evactivities, :college_id, :integer
    add_column :evactivities, :data, :string

    add_column :evaluate_courses, :college_id, :integer
    add_column :evaluate_courses, :data, :string

    add_column :evaluatecoursesearches, :college_id, :integer
    add_column :evaluatecoursesearches, :data, :string

    add_column :events, :college_id, :integer
    add_column :events, :data, :string

    add_column :exam_templates, :college_id, :integer
    add_column :exam_templates, :data2, :string
  
    add_column :examanalyses, :college_id, :integer
    add_column :examanalyses, :data, :string

    add_column :examanalysissearches, :college_id, :integer
    add_column :examanalysissearches, :data, :string

    add_column :examanswers, :college_id, :integer
    add_column :examanswers, :data, :string

    add_column :exammarks, :college_id, :integer
    add_column :exammarks, :data, :string

    add_column :exammcqanswers, :college_id, :integer
    add_column :exammcqanswers, :data, :string

    add_column :examquestionanalyses, :college_id, :integer
    add_column :examquestionanalyses, :data, :string

    add_column :examquestions, :college_id, :integer
    add_column :examquestions, :data, :string

    add_column :examquestions_exams, :college_id, :integer
    add_column :examquestions_exams, :data, :string

    add_column :examresults, :college_id, :integer
    add_column :examresults, :data, :string

    add_column :examresults_students, :college_id, :integer
    add_column :examresults_students, :data, :string

    add_column :examresultsearches, :college_id, :integer
    add_column :examresultsearches, :data, :string

    add_column :exams, :college_id, :integer
    add_column :exams, :data, :string

    add_column :examsearches, :college_id, :integer
    add_column :examsearches, :data, :string

    add_column :examsubquestions, :college_id, :integer
    add_column :examsubquestions, :data, :string

    add_column :fingerprints, :college_id, :integer
    add_column :fingerprints, :data, :string

    add_column :grades, :college_id, :integer
    add_column :grades, :data, :string

    add_column :groups, :college_id, :integer
    add_column :groups, :data, :string

    add_column :holidays, :college_id, :integer
    add_column :holidays, :data, :string

    add_column :intakes, :college_id, :integer
    add_column :intakes, :data, :string

    add_column :kins, :college_id, :integer
    add_column :kins, :data, :string

    add_column :leaveforstaffs, :college_id, :integer
    add_column :leaveforstaffs, :data, :string

    add_column :leaveforstudents, :college_id, :integer
    add_column :leaveforstudents, :data, :string

    add_column :lesson_plan_trainingnotes, :college_id, :integer
    add_column :lesson_plan_trainingnotes, :data, :string

    add_column :lesson_plans, :college_id, :integer
    add_column :lesson_plans, :data, :string

    add_column :lessonplan_methodologies, :college_id, :integer
    add_column :lessonplan_methodologies, :data, :string

    add_column :lessonplansearches, :college_id, :integer
    add_column :lessonplansearches, :data, :string

    add_column :librarytransactions, :college_id, :integer
    add_column :librarytransactions, :data, :string

    add_column :librarytransactionsearches, :college_id, :integer
    add_column :librarytransactionsearches, :data, :string

    add_column :loans, :college_id, :integer
    add_column :loans, :data, :string

    #add_column :location_damages, :college_id, :integer
    add_column :location_damages, :data, :string

    add_column :locations, :college_id, :integer
    add_column :locations, :data, :string

    add_column :mailboxer_conversation_opt_outs, :college_id, :integer
    add_column :mailboxer_conversation_opt_outs, :data, :string

    add_column :mailboxer_conversations, :college_id, :integer
    add_column :mailboxer_conversations, :data, :string

    add_column :mailboxer_notifications, :college_id, :integer
    add_column :mailboxer_notifications, :data, :string

    add_column :mailboxer_receipts, :college_id, :integer
    add_column :mailboxer_receipts, :data, :string

    add_column :maints, :college_id, :integer
    add_column :maints, :data, :string

    add_column :marks, :college_id, :integer
    add_column :marks, :data, :string

    add_column :mycpds, :college_id, :integer
    add_column :mycpds, :data, :string

    add_column :pages, :college_id, :integer
    add_column :pages, :data, :string

    add_column :personalizetimetablesearches, :college_id, :integer
    add_column :personalizetimetablesearches, :data, :string

    add_column :photos, :college_id, :integer
    add_column :photos, :data, :string

    add_column :positions, :college_id, :integer
    add_column :positions, :data, :string

    add_column :postinfos, :college_id, :integer
    add_column :postinfos, :data, :string

    add_column :programmes, :college_id, :integer
    add_column :programmes, :data, :string

    add_column :ptbudgets, :college_id, :integer
    add_column :ptbudgets, :data, :string

    add_column :ptcourses, :college_id, :integer
    add_column :ptcourses, :data, :string

    add_column :ptdos, :college_id, :integer
    add_column :ptdos, :data, :string

    add_column :ptdosearches, :college_id, :integer
    add_column :ptdosearches, :data, :string

    add_column :ptschedules, :college_id, :integer
    add_column :ptschedules, :data, :string

    add_column :qualifications, :college_id, :integer
    add_column :qualifications, :data, :string

    add_column :resultlines, :college_id, :integer
    add_column :resultlines, :data, :string

    add_column :roles, :college_id, :integer
    add_column :roles, :data, :string

    add_column :roles_users, :college_id, :integer
    add_column :roles_users, :data, :string

    add_column :scores, :college_id, :integer
    add_column :scores, :data, :string

    add_column :shift_histories, :college_id, :integer
    add_column :shift_histories, :data, :string
  
    add_column :shortessays, :college_id, :integer
    add_column :shortessays, :data, :string

    add_column :spmresults, :college_id, :integer
    add_column :spmresults, :data, :string

    add_column :staff_appraisal_skts, :college_id, :integer
    add_column :staff_appraisal_skts, :data, :string

    add_column :staff_appraisals, :college_id, :integer
    add_column :staff_appraisals, :data, :string

    add_column :staff_attendances, :college_id, :integer
    add_column :staff_attendances, :data, :string

    add_column :staff_grades, :college_id, :integer
    add_column :staff_grades, :data, :string

    add_column :staff_shifts, :college_id, :integer
    add_column :staff_shifts, :data, :string

    add_column :staffattendancesearches, :college_id, :integer
    add_column :staffattendancesearches, :data, :string

    add_column :staffs, :college_id, :integer
    add_column :staffs, :data, :string

    add_column :staffsearch2s, :college_id, :integer
    add_column :staffsearch2s, :data, :string

    add_column :stationeries, :college_id, :integer
    add_column :stationeries, :data, :string

    add_column :stationery_adds, :college_id, :integer
    add_column :stationery_adds, :data, :string

    add_column :stationery_uses, :college_id, :integer
    add_column :stationery_uses, :data, :string

    add_column :stationerysearches, :college_id, :integer
    add_column :stationerysearches, :data, :string

    add_column :student_attendances, :college_id, :integer
    add_column :student_attendances, :data, :string

    add_column :student_counseling_sessions, :college_id, :integer
    add_column :student_counseling_sessions, :data, :string

    add_column :student_discipline_cases, :college_id, :integer
    add_column :student_discipline_cases, :data, :string

    add_column :studentattendancesearches, :college_id, :integer
    add_column :studentattendancesearches, :data, :string

    add_column :studentcounselingsearches, :college_id, :integer
    add_column :studentcounselingsearches, :data, :string

    add_column :studentdisciplinesearches, :college_id, :integer
    add_column :studentdisciplinesearches, :data, :string

    add_column :students, :college_id, :integer
    add_column :students, :data, :string

    add_column :studentsearches, :college_id, :integer
    add_column :studentsearches, :data, :string

    add_column :tenants, :college_id, :integer
    add_column :tenants, :data, :string

    add_column :timetable_periods, :college_id, :integer
    add_column :timetable_periods, :data, :string

    add_column :timetables, :college_id, :integer
    add_column :timetables, :data, :string
  
    add_column :titles, :college_id, :integer
    add_column :titles, :data, :string

    add_column :topicdetails, :college_id, :integer
    add_column :topicdetails, :data, :string

    add_column :trainingnotes, :college_id, :integer
    add_column :trainingnotes, :data, :string

    add_column :trainingreports, :college_id, :integer
    add_column :trainingreports, :data, :string
  
    add_column :trainingrequests, :college_id, :integer
    add_column :trainingrequests, :data, :string

    add_column :trainneeds, :college_id, :integer
    add_column :trainneeds, :data, :string

    add_column :travel_claim_allowances, :college_id, :integer
    add_column :travel_claim_allowances, :data, :string

    add_column :travel_claim_logs, :college_id, :integer
    add_column :travel_claim_logs, :data, :string

    add_column :travel_claim_mileage_rates, :college_id, :integer
    add_column :travel_claim_mileage_rates, :data, :string

    add_column :travel_claim_receipts, :college_id, :integer
    add_column :travel_claim_receipts, :data, :string

    add_column :travel_claims, :college_id, :integer
    add_column :travel_claims, :data, :string

    add_column :travel_claims_transport_groups, :college_id, :integer
    add_column :travel_claims_transport_groups, :data, :string

    add_column :travel_requests, :college_id, :integer
    add_column :travel_requests, :data, :string

    add_column :users, :college_id, :integer
    add_column :users, :data, :string

    add_column :vehicles, :college_id, :integer
    add_column :vehicles, :data, :string

    add_column :weeklytimetable_details, :college_id, :integer
    add_column :weeklytimetable_details, :data, :string
  
    add_column :weeklytimetables, :college_id, :integer
    add_column :weeklytimetables, :data, :string
  
    add_column :weeklytimetablesearches, :college_id, :integer
    add_column :weeklytimetablesearches, :data, :string
  end
end

# ABOVE : 131 existing tables
# BELOW : 34 tables for checking
#   appraisals 
#   address_book_items
#   assetnums
#   assettracks
#   assetlosses 
#   attendances 
#   average_courses
#   counsellings
#   disposals 
#   exammakers
#   exammakers_examquestions
#   examtemplates 
#   klasses
#   klasses_students
#   logins
#   logins_roles
#   parts
#   programmes_subjects
#   residences
#   rxparts
#   messages
#   messages_staffs
#   schema_migrations
#   scsessions 
#   staffcourses 
#   staffemploygrades
#   staffemployschemes
#   staffsearches
#   studentattendancesearches
#   suppliers
#   trainings
#   traveldetails
#   traveldetailsreceipts
#   txsupplies
  
# NOTE
# exam_templates - data already exist/used
# location_damages - college_id already exist
