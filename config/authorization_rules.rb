privileges do
  privilege :approve,:includes => [:read, :update]
  privilege :manage, :includes => [:create, :read, :update, :delete, :approve, :menu]
  privilege :menu,   :includes => [:index]
  privilege :read,   :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end

authorization do

 role :administration do
   has_omnipotence
   has_permission_on :authorization_rules, :to => :read
 end

 #Group Staff

 role :staff do
   has_permission_on [:attendances, :documents],     :to => :menu              # Access for Menus
   has_permission_on :asset_assets, :to => [:menu, :loanables]
   has_permission_on [:staff_staff_attendances], :to => [:manager, :menu]
   #has_permission_on :staffs, :to => [:show, :menu]                                     # A staff see the staff list
   #has_permission_on :staffs, :to => [:edit, :update, :menu] do
   #  if_attribute :id => is {current_user.userable.id}                                  # but only sees himself
   #end
   ###
   has_permission_on :staffs, :to => [:update, :show, :borang_maklumat_staff] do #[:read, :update, :menu] do
    if_attribute :id => is {user.userable.id}
   end
   ###
   has_permission_on :staff_training_ptdos, :to => :create                                             # A staff can register for training session
   has_permission_on :staff_training_ptdos, :to => :index do
     if_attribute :staff_id => is {current_user.userable.id}                            # but onle see his own registrations
   end

   #has_permission_on :staff_staff_attendances, :to => [:index, :show, :new, :create, :edit, :update] do
   has_permission_on :staff_staff_attendances, :to => [:read, :update, :manager] do  #update - reason, #manager - manage lateness
     if_attribute :thumb_id => is {user.userable.thumb_id}
   end
#    has_permission_on :staff_staff_attendances, :to => [:index, :show, :approval, :update] do
#        if_attribute :approve_id => is {user.userable.id}  #approved_by (no field - approve_id)
#    end

   ###
   has_permission_on :student_student_discipline_cases, :to => :approve do 
      if_attribute :assigned_to =>  is {user.userable.id} 
    end
    has_permission_on :student_student_discipline_cases, :to => [:manage, :actiontaken] do
      if_attribute :assigned2_to => is {user.userable.id}
    end
   ####
   
   has_permission_on :staff_staff_appraisals, :to => :create
   has_permission_on :staff_staff_appraisals, :to => [ :update, :appraisal_form] do 
     if_attribute :eval1_by => is {user.userable.id}
   end
   has_permission_on :staff_staff_appraisals, :to => :manage, :join_by => :or do
       #if_attribute :staff_id => is {user.userable.id}
       if_attribute :eval1_by => is {user.userable.id}
       if_attribute :eval2_by => is {user.userable.id}
   end

   has_permission_on :staff_leaveforstaffs, :to => :create
   has_permission_on :staff_leaveforstaffs, :to => [:index, :show, :edit, :update] do
     if_attribute :staff_id => is {user.userable.id}
   end
   has_permission_on :staff_leaveforstaffs, :to => [:index, :show, :approve1, :update] do
       if_attribute :approval1_id => is {user.userable.id}
   end
   has_permission_on :staff_leaveforstaffs, :to => [:index, :show, :approve2, :update] do
       if_attribute :approval2_id => is {user.userable.id}
   end
   has_permission_on :staff_training_ptdos, :to => :delete do
       if_attribute :staff_id => is {user.userable.id}
   end

   has_permission_on :asset_asset_defects, :to => :create
   has_permission_on :asset_asset_defects, :to => [:read, :update]  do
       if_attribute :reported_by => is {user.userable.id}
   end
   has_permission_on :asset_asset_defects, :to => [:manage, :process2, :kewpa9] do
       if_attribute :processed_by => is {user.userable.id}
   end
   has_permission_on :asset_asset_defects, :to => [:manage, :decision, :kewpa9] do
       if_attribute :decision_by => is {user.userable.id}
   end
   
   has_permission_on :asset_asset_loans, :to => :create
   has_permission_on :asset_asset_loans, :to =>:read do 
      if_attribute :staff_id => is {user.userable.id}
   end
   has_permission_on :asset_loans, :to => [:read, :update, :approve, :lampiran_a] do
      if_attribute :loaned_by => is_in {AssetLoan.find(asset_id).unit_members}
   end

   has_permission_on :documents, :to => [:approve,:menu], :join_by => :or do
       if_attribute :stafffiled_id => is {current_user.userable.id}
       if_attribute :cc1staff_id => is {current_user.userable.id}
       if_attribute :cc2staff_id => is {current_user.userable.id}
   end

   #to works in travel request..28 August 2013
   has_permission_on :documents, :to => :index
   has_permission_on :staff_travel_requests, :to => :create

   has_permission_on :students, :to => :show ###temp - required for access to students menu items

    has_permission_on :student_student_discipline_cases, :to => :create
    has_permission_on :student_student_discipline_cases, :to => :approve do 
      if_attribute :assigned_to =>  is {user.userable.id} #is {current_user.userable.id}
    end
    has_permission_on :student_student_discipline_cases, :to => [:manage, :actiontaken] do
      if_attribute :assigned2_to => is {user.userable.id}
    end
    
    ###read - temp : to avoid using :read -> inc :index where necessary
    has_permission_on :student_student_discipline_cases, :to => :read do
      if_attribute :reported_by => is {user.userable.id}
    end
#    has_permission_on :student_discipline_cases, :to => :read, :join_by => :or do
#      if_attribute :reported_by => is {current_user.userable.id}
#      if_attribute :assigned_to => is {current_user.userable.id}
#      if_attribute :assigned2_to => is {current_user.userable.id}
#    end

   #disable this part first - suppose in index, view only - transaction where current_user is a borrower - but ALL record are displayed when this part is enable
   #has_permission_on :library_librarytransactions, :to => :read do
     #if_attribute :staff_id => is {current_user.userable.id}
   #end
   
   has_permission_on :library_books, :to => :read
   
 end

  role :staff_administrator do
     has_permission_on :staffs, :to => [:manage, :borang_maklumat_staff]
     has_permission_on :attendances, :to => :manage
     has_permission_on :staff_staff_attendances, :to =>[:manage, :manager, :actionable, :approval, :manager_admin, :attendance_report, :attendance_report_main, :daily_report, :weekly_report, :monthly_report, :monthly_listing, :monthly_details, :import_excel, :import, :status ]   #29Apr2013-refer routes.rb
     has_permission_on :staff_fingerprints, :to => [:manage, :approval, :index_admin]
     has_permission_on :staff_positions, :to =>[:manage, :maklumat_perjawatan]
  end
  
  role :finance_unit do
    has_permission_on [:travel_claims, :travel_claim_allowances, :travel_claim_receipts, :travel_claim_logs], :to => [:manage, :check, :approve]
    has_permission_on :staff_training_ptbudgets, :to => :manage
  end

   role :training_manager do
     has_permission_on [:staff_training_ptbudgets, :staff_training_ptcourses, :staff_training_ptschedules], :to => :manage
     has_permission_on :staff_training_ptdos, :to =>:approve
   end
 
   role :training_administration do
     has_permission_on [:staff_training_ptbudgets, :staff_training_ptcourses, :staff_training_ptschedules], :to => :manage
     has_permission_on :staff_training_ptdos, :to => :approve
   end

 #Group Assets  -------------------------------------------------------------------------------
 role :asset_administrator do
   has_permission_on :asset_assets, :to => [:manage, :kewpa2, :kewpa3, :kewpa4, :kewpa5, :kewpa6, :kewpa13, :kewpa14, :loanables]
   has_permission_on :asset_defects, :to =>[:manage, :kewpa9] #3nov2013
   has_permission_on :assetsearches, :to => :read
   has_permission_on :locations, :to => :manage
   has_permission_on :asset_disposals, :to => :manage
   has_permission_on :asset_losses, :to => :manage
   has_permission_on :asset_loans, :to => [:manage, :approve, :lampiran_a]
 end

 #Group Trainings ------------------------------------------------------------read(index, show), menu(inc index), update(inc edit), approve(read, update), manage(crud,approve,menu)
 role :lecturer do

   ###HOLD first - works well in Catechumen but not in ogma - just let all lecturers access, afterall only coordinator/programme lecture appear in the list! 
   ##HIDE ON 17MAY2015--has_permission_on :student_leaveforstudents, :to => [:index, :menu, :create, :show, :update, :approve_coordinator]
   #prob - if warden(not lecturer) ok, if warden also lecturer-tak boleh,....staff --> index, menu, create, show, update??, 
   
   #restricted access for penyelaras - [relationship: approver, FK: staff_id, page: approve], in case of non-exist of penyelaras other lecturer fr the same programme
   #has_permission_on :student_leaveforstudents, :to => [:index, :menu, :create, :show, :update, :approve], :join_by => :and do
      #if_attribute :studentsubmit => true
      #if_attribute :student_id => is_in {[334]}  #is_in {user.under_my_supervision} 
   #end
   
   #revised - 17May2015-start
   #restricted access for penyelaras - [relationship: approver, FK: staff_id, page: approve], in case of non-exist of penyelaras other lecturer fr the same programme
    has_permission_on :student_leaveforstudents, :to => [:index,:menu, :create, :show, :update, :approve_coordinator, :slip_pengesahan_cuti_pelajar] do #, :join_by => :and do
      if_attribute :studentsubmit => true
      #if_attribute :student_id => is_in {user.under_my_supervision} - not working - access 'under_my_supervision' method from controller & model via 'search2'
    end
    #revised - 17May2015-end
   
   #EXAMINATION modules
   has_permission_on [:exam_examquestions, :exam_exams, :exam_exammarks, :exam_grades], :to => [:menu, :read, :create]
 
   has_permission_on :exam_exams, :to =>:manage do
     if_attribute :created_by => is {user.userable.id}
   end
   
   has_permission_on :exam_examquestions, :to =>:update, :join_by => :and do
     if_attribute :creator_id => is {user.userable.id}
     if_attribute :qstatus => is {"New"}
   end
   #any other lecturer from the same programme can be an EDITOR
   has_permission_on :exam_examquestions, :to =>:update, :join_by => :and do
     if_attribute :creator_id => is_not {user.userable.id}
     if_attribute :qstatus => is {"Submit"}
   end
   #if EDITOR hold record first, for later editing, must be the same person
   has_permission_on :exam_examquestions, :to => :update, :join_by => :and do
     if_attribute :editor_id => is {user.userable.id}
     if_attribute :qstatus => is {"Editing"}
   end
   #HOD can approve although not assigned - role:programme_manager
   has_permission_on :exam_examquestions, :to => :manage do
     if_attribute :approver_id => is {user.userable.id}
   end
   #Ready for approval - HOD classify as Re-Edit, return to editor
   has_permission_on :exam_examquestions, :to =>:update, :join_by => :and do
     if_attribute :editor_id => is {user.userable.id}
     if_attribute :qstatus => is {"Re-Edit"}
   end
   
   has_permission_on :exam_exammarks, :to =>[:update, :delete, :edit_multiple, :update_multiple, :new_multiple, :create_multiple] do
     if_attribute :exam_id => is_in {user.exams_of_programme}
   end
   
   #pending - just in case other programme's grade appear in current programme index page?
   has_permission_on :exam_grades, :to => [:update, :edit_multiple, :update_multiple, :new_multiple, :create_multiple] do
     if_attribute :subject_id => is_in {user.grades_of_programme}
   end
   
   #has_permission_on :exam_evaluate_courses, :to => :manage - evaluation supposed by student - lecturer being evaluate shouldn't hv EDIT access
   has_permission_on :exam_evaluate_courses, :to =>[:index, :show, :courseevaluation] do
     if_attribute :staff_id => is {user.userable.id}
   end
   has_permission_on :student_student_attendances, :to => [:manage, :new_multiple, :new_multiple_intake, :create_multiple, :edit_multiple, :update_multiple, :student_attendan_form]
   
   #TRAINING modules
   #HACK : INDEX (new) - restricted access except for Penyelaras Kumpulan (diploma & posbasics)
   has_permission_on :training_weeklytimetables, :to => [:menu, :read, :create]
   
   #HACK : INDEX (list+show)- restricted access except for Penyelaras Kumpulan/Ketua Program/Ketua Subjek(+'unit_leader' role)/Administration/creator(prepared_by)
   #HACK : SHOW (+edit) - restricted access UNLESS is_submitted!=true (+submission only allowed for Penyelaras Kumpulan)
   has_permission_on :training_weeklytimetables, :to => [:manage, :weekly_timetable] 
   
   has_permission_on :training_weeklytimetables, :to => [:personalize_index, :personalize_show, :personalize_timetable, :personalizetimetable] do
       if_attribute :staff_id => is {user.userable_id}
   end
   
   has_permission_on :training_trainingnotes, :to => :manage, :join_by => :or do
     if_attribute :topicdetail_id => is_in {user.topicdetails_of_programme}
     if_attribute :timetable_id => is_in {user.timetables_of_programme} 
   end
   
   has_permission_on :training_trainingnotes, :to => :manage, :join_by => :and do
     if_attribute :topicdetail_id => is {nil}
     if_attribute :timetable_id => is {nil}
   end
 end

 role :programme_manager do
   has_permission_on [:exam_examquestions, :exam_exams], :to => :manage
   has_permission_on :exam_exammarks, :to => [:manage, :edit_multiple, :update_multiple, :new_multiple, :create_multiple]
   has_permission_on :exam_evaluate_courses, :to => :create 
   has_permission_on :exam_evaluate_courses, :to => [:manage, :courseevaluation] do
     if_attribute :course_id => is {user.evaluations_of_programme}
   end
   has_permission_on :staff_training_ptdos, :to => :approve do
     if_attribute :staff_id => is_in {user.unit_members}#is {69}#is_in {[69, 106]}  #
   end
   has_permission_on :staff_staff_attendances, :to => :approval do
     if_attribute :thumb_id => is_in {user.admin_unitleaders_thumb}
   end   
   #SHOW (approval button) & approval action
   has_permission_on :training_weeklytimetables, :to => :approval do
     if_attribute :is_submitted => is {true}
   end
   has_permission_on :training_programmes, :to => :manage
 end
 
 #Group Library   -------------------------------------------------------------------------------

  role :librarian do
    has_permission_on :library_books, :to => [:manage, :extend, :return, :import_excel]
    has_permission_on :library_librarytransactions, :to => [:manage, :extend, :extend2,:return,:return2, :check_availability, :form_try, :multiple_edit,:check_availability2,:multiple_update]#,:accession_list]
    has_permission_on :students, :to => [:read, :borang_maklumat_pelajar]
    #has_permission_on :booksearches, :to => :read
    #has_permission_on :librarytransactionsearches, :to => :read
  end

#Group Student --------------------------------------------------------------------------------
  role :student do
      has_permission_on :exam_evaluate_courses, :to => [:index, :create]
      has_permission_on :exam_evaluate_courses, :to => [:read, :courseevaluation] do
        if_attribute :student_id => is {user.userable.id}  #student_id
      end
      has_permission_on :students, :to => [:update, :show, :borang_maklumat_pelajar] do #[:read, :update, :menu] do
        if_attribute :id => is {user.userable.id}
      end
      has_permission_on :student_leaveforstudents, :to =>[:index, :create]
      has_permission_on :student_leaveforstudents, :to => [:show, :update, :slip_pengesahan_cuti_pelajar] do
        if_attribute :student_id => is {user.userable.id}
      end
  end
 
  role :student_administrator do
     has_permission_on :students, :to => [:manage, :borang_maklumat_pelajar, :reports, :student_report, :ethnic_listing, :kumpulan_etnik, :kumpulan_etnik_main, :kumpulan_etnik_excel,:import, :import_excel, :download_excel_format, :students_quantity_sponsor, :students_quantity_report] 
  end

   role :disciplinary_officer do
     has_permission_on :student_student_discipline_cases, :to => [:manage, :reports, :discipline_report, :anacdotal_report]
     has_permission_on :student_student_counseling_sessions, :to => :feedback_referrer do
       if_attribute :case_id =>  is_not {nil}
     end
   end

#####
#   role :student_counsellor do
#     has_permission_on :student_counseling_sessions, :to => [:manage, :feedback_referrer]
#     has_permission_on :students, :to => :core
#     has_permission_on :studentcounselingsearches, :to => :read
#   end
#####
  
  #Group Location --------------------------------------------------------------------------------
  role :warden do
    has_permission_on :locations, :to => :core
    #all wardens have access - [relationship: second_approver, FK: staff_id2, page: approve_warden]
    has_permission_on :student_leaveforstudents, :to => [:index, :menu, :create, :show, :update, :approve_warden] do
      if_attribute :studentsubmit => true
    end
    has_permission_on :library_books, :to => :read
    has_permission_on :asset_assets, :to => :read
    has_permission_on :students, :to => :read
  end
  
  role :unit_leader do
    has_permission_on :staff_training_ptdos, :to => :approve do
      if_attribute :staff_id => is_in {user.unit_members}
    end
    has_permission_on :staff_staff_attendances, :to => :approval do  # :to =>[:manage, :actionable, :approve] do
      if_attribute :thumb_id => is_in {user.unit_members_thumb}
    end
    has_permission_on :training_programmes, :to => :manage, :join_by => :and do
      if_attribute :name => is {user.positions.first.unit}
      if_attribute :course_type => is {"Commonsubject"}
    end
  end
  
  role :administration_staff do
    #access for Timbalan Pengarah (Pengurusan)
    has_permission_on :staff_training_ptdos, :to => :approve do
      if_attribute :staff_id => is_in {user.admin_subordinates}
    end
    #access for Timbalan Pengarah (Pengurusan) & Pengarah(Timbalans+Ketua2 Programs)
    has_permission_on :staff_staff_attendances, :to => :approval do
      if_attribute :thumb_id => is_in {user.admin_unitleaders_thumb}
    end
    has_permission_on :staff_staff_fingerprints, :to => :approval do
      if_attribute :thumb_id => is_in {user.admin_unitleaders_thumb}
    end
  end
  
  role :guest do
    #has_permission_on :users, :to => :create
    #has_permission_on :library_books, :to => :read   
    #hide ALL modules from guest first --> 14 March 2015 & temporary add 3 items for permission for warden library_books, assets & students
    #coz roles assign for guest - accessible to user WITHOUT LOGIN due to firefox/Ie - unsupported version (old version)
  end



end

=begin
# Standard Roles applied to application
# Add to your db/seeds.rb
# try to ensure these are in sync
# data here should be master
# add a role via migration if creating a new one to ensure authorisation access is enabled here
roles = Role.create([
  {:name => 'Login',                  :authname => 'user'},
  {:name => 'Administration',         :authname => 'administration'},
  {:name => 'Student',                :authname => 'student'},
  {:name => 'Administration Staff',   :authname => 'administration_staff'},
  {:name => 'Librarian',              :authname => 'librarian'},
  {:name => 'Staff',                  :authname => 'staff'},
  {:name => 'Warden',                 :authname => 'warden'},
  {:name => 'Training Administration',:authname => 'training_administration'},
  {:name => 'Training Manager',       :authname => 'training_manager'},
  {:name => 'Asset Administrator',    :authname => 'asset_administrator'},
  {:name => 'Student Counsellor',     :authname => 'student_counsellor'},
  {:name => 'Facilities Administrator', :authname => 'facilities_administrator'},
  {:name => 'Lecturer',               :authname => 'lecturer'},
  {:name => 'Student Administrator',  :authname => 'student_administrator'},
  {:name => 'Staff Administrator',    :authname => 'staff_administrator'},
  {:name => 'E-Filing',               :authname => 'e_filing'},
  {:name => 'Programme Manager',      :authname => 'programme_manager'},
  {:name => 'Disciplinary Officer',   :authname => 'disciplinary_officer'},
  {:name => 'Guest',                  :authname => 'guest'}
])
=end


=begin
  #authorization rules for roles copy paste implements in accordance to security matrix
  role :administration do
    has_omnipotence
    has_permission_on :authorization_rules, :to => :read
    #Staff Menu Items
    #has_permission_on :staffs,          :to => [:manage, :borang_maklumat_staff]
    has_permission_on :attendances,     :to => [:manage, :approve]
    #appraisals
    #positions
    has_permission_on :leaveforstaffs,  :to => [:manage, :approve1, :approve2]
    #claims
    has_permission_on [:ptbudgets, :ptcourses, :ptschedules, :ptdos],  :to => :manage   #Professional Development
    #status & movement
    #reports

    #Asset Menu Items
    has_permission_on :assets,      :to => :manage                              #asset items

    #Location Menu Items
    has_permission_on :locations,   :to => :manage                              #location items

    #E-Filing Menu Items
    has_permission_on :documents, :to => [:manage, :generate_report]                 #e-filing items

    #Student Menu Items
    #has_permission_on :students,        :to => [:manage, :formforstudent, :maklumat_pelatih_intake]
    #has_permission_on [:leaveforstudents],  :to => :manage #

    #Exam Menu Items
    has_permission_on :examquestions,   :to => :manage

    #Training Menu Items
    has_permission_on :programmes, :to => :manage
    has_permission_on :timetables, :to => :manage
    has_permission_on :weeklytimetables, :to => :manage
    #Library Menu Items
    has_permission_on [:librarytransactions, :books], :to => :manage

    #Administration Menu Items
    has_permission_on [:users, :roles, :pages],  :to => :manage #stuff in admin menu

    #Equery Menu Items
    has_permission_on :staffsearch2s, :to => :read
    has_permission_on :assetsearches, :to => :read
    has_permission_on :documentsearches, :to => :read
    has_permission_on :studentsearches, :to => :read
    has_permission_on :studentattendancesearches, :to => :read
    has_permission_on :studentdisciplinesearches, :to => :read
    has_permission_on :studentcounselingsearches, :to => :read
    has_permission_on :weeklytimetablesearches, :to => :read
    has_permission_on :curriculumsearches, :to => :read
    has_permission_on :lessonplansearches, :to => :read
    has_permission_on :personalizetimetablesearches, :to => :read
    has_permission_on :examsearches, :to => :read
    has_permission_on :examresultsearches, :to => :read
    has_permission_on :evaluatecoursesearches, :to => :read
    has_permission_on :examanalysissearches, :to => :read
    has_permission_on :booksearches, :to => :read
    has_permission_on :librarytransactionsearches, :to => :read
  end


  #Group Staff

  role :staff do
    has_permission_on :authorization_rules, :to => :read
    has_permission_on [:attendances, :assets, :documents],     :to => :menu              # Access for Menus
    has_permission_on :books, :to => :core
    has_permission_on :ptdos, :to => :create
    has_permission_on :ptdos, :to => :index do
      if_attribute :staff_id => is {Login.current_login.staff_id}
    end
    has_permission_on :staffs, :to => [:show, :menu]
    has_permission_on :staffs, :to => [:edit, :update, :menu] do
      if_attribute :id => is {Login.current_login.staff_id}
    end
    has_permission_on :attendances, :to => [:index, :show, :new, :create, :edit, :update] do
      if_attribute :staff_id => is {Login.current_login.staff_id}
    end
    has_permission_on :attendances, :to => [:index, :show, :approve, :update] do
        if_attribute :approve_id => is {Login.current_login.staff_id}
    end

    has_permission_on :staff_appraisals, :to => :create
    has_permission_on :staff_appraisals, :to => :manage, :join_by => :or do
        if_attribute :staff_id => is {Login.current_login.staff_id}
        if_attribute :eval1_by => is {Login.current_login.staff_id}
        if_attribute :eval2_by => is {Login.current_login.staff_id}
    end

    has_permission_on :leaveforstaffs, :to => :create
    has_permission_on :leaveforstaffs, :to => [:index, :show, :edit, :update] do
      if_attribute :staff_id => is {Login.current_login.staff_id}
    end
    has_permission_on :leaveforstaffs, :to => [:index, :show, :approve1, :update] do
        if_attribute :approval1_id => is {Login.current_login.staff_id}
    end
    has_permission_on :leaveforstaffs, :to => [:index, :show, :approve2, :update] do
        if_attribute :approval2_id => is {Login.current_login.staff_id}
    end
    has_permission_on :ptdos, :to => :delete do
        if_attribute :staff_id => is {Login.current_login.staff_id}
    end

    has_permission_on :asset_defects, :to => :create
    has_permission_on :asset_defects, :to => [:read, :update]  do
        if_attribute :reported_by => is {Login.current_login.staff_id}
    end
    has_permission_on :asset_defects, :to => [:manage]  do
        if_attribute :decision_by => is {Login.current_login.staff_id}
    end

    has_permission_on :documents, :to => [:approve,:menu], :join_by => :or do
        if_attribute :stafffiled_id => is {Login.current_login.staff_id}
        if_attribute :cc1staff_id => is {Login.current_login.staff_id}
        if_attribute :cc2staff_id => is {Login.current_login.staff_id}
    end

    #to works in travel request..28 August 2013
    #has_permission_on :documents, :to => :index


    has_permission_on :student_discipline_cases, :to => :create
    has_permission_on :student_discipline_cases, :to => :approve do
      if_attribute :assigned_to => is {Login.current_login.staff_id}
    end
    has_permission_on :student_discipline_cases, :to => :manage do
      if_attribute :assigned2_to => is {Login.current_login.staff_id}
    end
    has_permission_on :student_discipline_cases, :to => :read, :join_by => :or do
      if_attribute :reported_by => is {Login.current_login.staff_id}
      if_attribute :assigned_to => is {Login.current_login.staff_id}
      if_attribute :assigned2_to => is {Login.current_login.staff_id}
    end

    has_permission_on :librarytransactions, :to => :read do
      if_attribute :staff_id => is {Login.current_login.staff_id}
    end
  end

  role :staff_administrator do
     has_permission_on :staffs, :to => [:manage, :borang_maklumat_staff]
     has_permission_on :attendances, :to => :manage
     has_permission_on :staff_attendances, :to => :manage   #29Apr2013-refer routes.rb
     has_permission_on :staffsearch2s, :to => :read
  end

  role :finance_unit do
    has_permission_on [:travel_claims, :travel_claim_allowances, :travel_claim_receipts, :travel_claim_logs], :to => [:manage, :check, :approve]
  end

  role :training_manager do
    has_permission_on [:ptbudgets, :ptcourses, :ptschedules], :to => :manage
  end

  role :training_administration do
    has_permission_on [:ptcourses, :ptschedules], :to => :manage
    has_permission_on :ptdos, :to => :approve
  end

  #Group Assets  -------------------------------------------------------------------------------
  role :asset_administrator do
    has_permission_on :assets, :to => :manage
    has_permission_on :asset_defects, :to =>[:manage, :kewpa9] #3nov2013
    has_permission_on :assetsearches, :to => :read
  end


  #Group Locations  -------------------------------------------------------------------------------
  role :facilities_administrator do
    has_permission_on :locations, :to => [:manage, :indextree]
    has_permission_on :tenants, :to => :manage
    #has_permission_on :leaveforstudents, :to => :manage
  end

  role :warden do
    has_permission_on :locations, :to => :core
    has_permission_on :leaveforstudents, :to => :manage
    #has_permission_on :leaveforstudents, :to => [:index,:create, :show, :update, :approve] do
      #if_attribute :studentsubmit => true
    #end
  end

  #Group E-Filing -------------------------------------------------------------------------------
  role :e_filing do
    has_permission_on :cofiles, :to => :manage
    has_permission_on :documents, :to => [:manage, :generate_report] #do
        #if_attribute :prepared_by => is {Login.current_login.staff_id}
        #if_attribute :stafffiled_id => is {Login.current_login.staff_id}
    #end
    has_permission_on :documentsearches, :to => :read
  end

  #Group Student --------------------------------------------------------------------------------
  role :student do

      has_permission_on :locations, :to => :menu

      has_permission_on :tenants, :to => :read do
        if_attribute :student_id => is {Login.current_login.student_id}
      end

      #has_permission_on :student_counseling_sessions, :to => :create
      #has_permission_on :student_counseling_sessions, :to => :show do         
    Perpustakaan


        #if_attribute :student_id => is {Login.current_login.student_id}
      #end

      has_permission_on :programmes, :to => :menu
      has_permission_on :books, :to => :core
      has_permission_on :students, :to => [:read, :update, :menu] do
        if_attribute :student_id => is {Login.current_login.student_id}
      end
      has_permission_on :leaveforstudents, :to => [:read, :update] do
        if_attribute :student_id => is {Login.current_login.student_id}
      end
      has_permission_on :leaveforstudents, :to => [:create]
  end

  role :student_administrator do
     has_permission_on :students, :to => [:manage, :formforstudent, :maklumat_pelatih_intake, :ethnic_listing]
     has_permission_on :studentsearches, :to => :read
  end

  role :disciplinary_officer do
    has_permission_on :student_discipline_cases, :to => :manage
    has_permission_on :student_counseling_sessions, :to => :feedback_referrer
    has_permission_on :studentdisciplinesearches, :to => :read
  end

  role :student_counsellor do
    has_permission_on :student_counseling_sessions, :to => [:manage, :feedback_referrer]
    has_permission_on :students, :to => :core
    has_permission_on :studentcounselingsearches, :to => :read
  end

  #Group Training  -------------------------------------------------------------------------------

  role :programme_manager do
    has_permission_on :programmes, :to => :manage
    has_permission_on :timetables, :to => :manage#:to => [:index, :show, :edit, :update, :menu, :calendar]
    has_permission_on :topics, :to => :manage
    has_permission_on :weeklytimetables, :to => :manage #21March2013 added
  end
#--21march2013-new role added
  role :coordinator do
    has_permission_on :programmes, :to => :manage
    has_permission_on :timetables, :to => :manage
    has_permission_on :weeklytimetables, :to => :manage do
      if_attribute :prepared_by => is {Login.current_login.staff_id}
    end
 end
#--21march2013-new role added
  role :lecturer do
    has_permission_on :examquestions, :to => :manage
    has_permission_on :programmes, :to => [:core,:menu]
    has_permission_on :topics, :to => :manage
    has_permission_on :timetables, :to => [:index, :show, :edit, :update, :menu, :calendar] do
      if_attribute :staff_id => is {Login.current_login.staff_id}
    end
    has_permission_on :trainingreports, :to => :manage, :join_by => :or do
      if_attribute :staff_id => is {Login.current_login.staff_id}
      if_attribute :tpa_id => is {Login.current_login.staff_id}
    end
    has_permission_on :timetables, :to => [:create]
    has_permission_on :student_attendances, :to => :manage  #10July2013
    has_permission_on :weeklytimetables, :to => :personalize_index do
      if_attribute :staff_id => is {Login.current_login.staff_id}
    end
    has_permission_on :studentattendancesearches, :to => :read
    has_permission_on :weeklytimetablesearches, :to => :read
    has_permission_on :curriculumsearches, :to => :read
    has_permission_on :lessonplansearches, :to => :read
    has_permission_on :personalizetimetablesearches, :to => :read
    has_permission_on :examsearches, :to => :read
    has_permission_on :examresultsearches, :to => :read
    has_permission_on :evaluatecoursesearches, :to => :read
    has_permission_on :examanalysissearches, :to => :read
  end


  #Group Exams   -------------------------------------------------------------------------------

  #Group Library   -------------------------------------------------------------------------------

  role :librarian do
    has_permission_on :books, :to => [:manage, :extend, :return]
    has_permission_on :librarytransactions , :to => [:manage, :extend, :extend2,:return,:return2, :check_availability, :form_try, :multiple_edit,:check_availability2,:multiple_update]#,:accession_list]
    has_permission_on :students, :to => :index
    has_permission_on :booksearches, :to => :read
    has_permission_on :librarytransactionsearches, :to => :read
  end

  role :guest do
    has_permission_on :users, :to => :create
    has_permission_on :books, :to => :core
  end

end

  privileges do
    privilege :approve,:includes => [:read, :update]
    privilege :manage, :includes => [:create, :read, :update, :delete, :core, :approve, :menu]
    privilege :menu,   :includes => [:index]
    privilege :read,   :includes => [:index, :show]
    privilege :create, :includes => :new
    privilege :update, :includes => :edit
    privilege :delete, :includes => :destroy
  end

=end
