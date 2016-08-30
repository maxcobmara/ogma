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
   has_permission_on :staff_staffs, :to => :menu                                                                 # A staff see the staff list
   has_permission_on :staff_staffs, :to => [:read, :update, :borang_maklumat_staff] do
     if_attribute :id => is {user.userable.id}                                                                         # but only sees himself
   end
   
   # NOTE - approval(lateness / early return) for Unit Members requires - Unit Leader role...temp
   # Previous acceptance Jan/Feb 2013 of Positions - not in the TREE form(parent-child), whereby flexible Unit Members can be put anywhere - with conditions - same UNIT
   # LATEST acceptance Dec 2015/Jan 2016-organisation chart - requires TREE format (parent-child: HOD-members) 
   has_permission_on [:staff_staff_attendances], :to => :manager                                      # manager - manage lateness / early - own / subordinate
   has_permission_on :staff_staff_attendances, :to => [:show, :update] do                        # show & update - to enter reason
     if_attribute :thumb_id => is {user.userable.thumb_id}
   end
   has_permission_on :staff_fingerprints, :to => :create                                                      # issue Fingerprint statement
   has_permission_on :staff_fingerprints, :to => [:read, :update] do                                   # index, show, update (own) Fingerprint statement
     if_attribute :thumb_id => is {user.userable.thumb_id}
   end
   
   has_permission_on :staff_training_ptschedules, :to => :menu
   has_permission_on :staff_training_ptdos, :to => :create                                                  # A staff can register for training session
   has_permission_on :staff_training_ptdos, :to => [:read, :show_total_days, :training_report, :delete] do
     if_attribute :staff_id => is {user.userable.id}                                                                 # but onle see his own registrations
   end
   
   has_permission_on :staff_instructor_appraisals, :to => :menu
   has_permission_on :staff_instructor_appraisals, :to => :create
   has_permission_on :staff_instructor_appraisals, :to => :update do
     if_attribute :staff_id => is {user.userable.id}
   end
   has_permission_on :staff_instructor_appraisals, :to => :read, :join_by => :or do
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :check_qc => is {user.userable.id}
   end
   
   has_permission_on :staff_staff_appraisals, :to => :create                                                # A staff can create appraisal
   has_permission_on :staff_staff_appraisals, :to => [:show, :appraisal_form] do                                             # but cannot see marking parts
     if_attribute :staff_id => is {user.userable.id}
   end
   has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do              # can enter SKT, when skt not yet submitted
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :is_skt_submit => is_not {true}
   end
   has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do              # can review SKT, when skt endorsed, but review/report not done
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :is_skt_endorsed => is {true}
     if_attribute :is_skt_pyd_report_done => is_not {true}
   end
   has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do              # can enter Training Needed, when skt PPP report is done & submit 4 evaluation
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :is_skt_ppp_report_done => is {true}
     if_attribute :is_submit_for_evaluation => is_not {true}
   end
   has_permission_on :staff_staff_appraisals, :to =>[:read, :appraisal_form], :join_by => :or do  # PPP & PPK have read access
     if_attribute :eval1_by => is {user.userable.id}
     if_attribute :eval2_by => is {user.userable.id}
   end
   has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do             # PPP can endorse SKT
     if_attribute :eval1_by => is {user.userable.id}
     if_attribute :is_skt_submit => is {true}
     if_attribute :is_skt_endorsed => is_not{true}
   end
   has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do             # PPP can complete reviewed SKT
     if_attribute :eval1_by => is {user.userable.id}
     if_attribute :is_skt_pyd_report_done => is {true}
     if_attribute :is_skt_ppp_report_done => is_not {true}
   end
   has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do             # PPP can evaluate when PYD submit 4 evaluation
     if_attribute :eval1_by => is {user.userable.id}
     if_attribute :is_submit_for_evaluation => is {true}
     if_attribute :is_submit_e2 => is_not {true}
   end
   has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do             # PPK can evaluate when evaluation by PPP was done
     if_attribute :eval2_by => is {user.userable.id}
     if_attribute :is_submit_e2 => is {true}
     if_attribute :is_complete => is_not {true}
   end

   has_permission_on :staff_leaveforstaffs, :to => :create                                                       # A staff can register for leave
   has_permission_on :staff_leaveforstaffs, :to => :read do                                                    # Staff can view his leave 
     if_attribute :staff_id => is {user.userable.id}
   end
   has_permission_on :staff_leaveforstaffs, :to =>  :delete, :join_by => :and do                    # Staff can delete as long as it is not processed yet
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :approval1 => is_not {true}
   end
   has_permission_on :staff_leaveforstaffs, :to => :read, :join_by => :or do                          # Penyokong and pelulus can view staff leave
      if_attribute :approval1_id => is {user.userable.id}
      if_attribute :approval2_id => is {user.userable.id}
    end
   has_permission_on :staff_leaveforstaffs, :to => [:processing_level_1, :update], :join_by => :and do  # Penyokong can update as long as not process by Pelulus
     if_attribute :approval1_id => is {user.userable.id}
     if_attribute :approval1 => is_not {true}
   end
   has_permission_on :staff_leaveforstaffs, :to => [:processing_level_2, :update], :join_by => :and do   # Pelulus can approve leave
     if_attribute :approval2_id => is {user.userable.id}
     if_attribute :approval1 => is {true}
     if_attribute :approver2 => is_not {true}
   end

   has_permission_on :staff_travel_requests, :to => [:menu, :create, :travel_log_index]
   has_permission_on :staff_travel_requests, :to => [:read, :status_movement], :join_by => :or do
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :hod_id => is {user.userable.id}
   end
   has_permission_on :staff_travel_requests, :to => :update, :join_by => :and do
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :is_submitted => is_not {true}
   end
   has_permission_on :staff_travel_requests, :to => [:approval, :update], :join_by => :and do   # TODO - HOD must not hv access to EDIT request, only APPROVAL
     if_attribute :hod_id => is {user.userable.id}
     if_attribute :is_submitted => is {true}
   end
   has_permission_on :staff_travel_requests, :to => [:travel_log, :update], :join_by => :and do  # TODO - Applicant must not hv access to EDIT request, only TRAVEL LOG
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :hod_accept => is {true}
   end
   
   has_permission_on :staff_travel_claims, :to => [:menu, :create]                                              # A staff can register Travel Claims
   has_permission_on :staff_travel_claims, :to => [:read, :claimprint], :join_by => :or do            # Applicant / Approver may show / pdf (Finance - refer role)
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :approved_by => is {user.userable.id}
   end
   has_permission_on :staff_travel_claims, :to => :update, :join_by => :and do                          # Applicant may update unless submitted
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :is_submitted => is_not {true}
   end
   has_permission_on :staff_travel_claims, :to => :update, :join_by => :and do                          # Applicant may update returned application (by FInance Unit)
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :is_checked => is {false}
     if_attribute :is_returned => is {true}
   end
   has_permission_on :staff_travel_claims, :to => [:approve, :update], :join_by => :and do        # Approver may approve if not yet approve
     if_attribute :approved_by => is {user.userable.id}
     if_attribute :is_approved => is_not {true}
   end
   
   has_permission_on :asset_assets, :to => [:read, :loanables]                                                  # A staff may read(w/o price): defect, writeoff, loan, location dmg
   has_permission_on :asset_asset_defects, :to => :create                                                        # A staff can register & update defect
   has_permission_on :asset_asset_defects, :to => :read do
     if_attribute :reported_by => is {user.userable.id}
   end
   has_permission_on :asset_asset_defects, :to => [:read, :kewpa9], :join_by => :and do        # Processor & decion maker may show / pdf
     if_attribute :processed_by => is {user.userable.id}
     if_attribute :decision_by => is {user.userable.id}
   end
   has_permission_on :asset_asset_defects, :to => :update, :join_by => :and do                     # Applicant may update unless defect processed
     if_attribute :reported_by => is {user.userable.id}
     if_attribute :is_processed => is_not {true}
   end
   has_permission_on :asset_asset_defects, :to => [:update, :process2, :kewpa9], :join_by => :and do  # previous Asset Admin - pending - may process unless defect processed
     if_attribute :processed_by => is {user.userable.id}
     if_attribute :is_processed => is_not {true}
   end
   has_permission_on :asset_asset_defects, :to => [:update, :decision, :kewpa9], :join_by => :and do   # Decision maker may decide unless decision has been made
     if_attribute :decision_by => is {user.userable.id}
     if_attribute :decision => is_not {true}
   end
   
   has_permission_on :asset_asset_loans, :to => :create                                                          # A staff can create loan
   has_permission_on :asset_asset_loans, :to =>:read do 
     if_attribute :staff_id => is {user.userable.id}
   end
   has_permission_on :asset_asset_loans, :to =>:update, :join_by => :and do                         # applicant can update unless loan is approved
     if_attribute :staff_id => is {user.userable.id}
     if_attribute :is_approved => is_not {true}
   end
   has_permission_on :asset_asset_loans, :to => [:read, :lampiran_a] do                                 # loan can be viewed by Unit Members
     if_attribute :loaned_by => is_in {user.unit_members}
   end
   has_permission_on :asset_asset_loans, :to => [:update, :approval], :join_by => :and do     # loan can be approved by Unit Members when not yet approved 
     if_attribute :loaned_by => is_in {user.unit_members}
     if_attribute :is_approved => is_not {true}
   end
   has_permission_on :asset_asset_loans, :to => :update, :join_by => :and do                         # As of Travel Request,Claim, AssetDefect - loaner must not hv access to EDIT 
     if_attribute :loaned_by => is_in {user.unit_members}                                                           # temp - hide in Edit as of Travel Claim & AssetDefect
     if_attribute :is_approved => is {true}
     if_attribute :is_returned => is_not {true}
   end
   
   has_permission_on :student_student_discipline_cases, :to => [:menu, :create]                     # A staff can register discipline case
   has_permission_on :student_student_discipline_cases, :to => :delete, :join_by => :and do   # reporter can remove case before action type entered by Programme Mgr
     if_attribute :reported_by => is {user.userable.id}
     if_attribute :action_type => is {nil}
   end
   has_permission_on :student_student_discipline_cases, :to => :read do                                 # reporter have access to read cases
     if_attribute :reported_by => is {user.userable.id}
   end
   has_permission_on :student_student_discipline_cases, :to => [:read, :discipline_report, :anacdotal_report], :join_by => :or do        
     if_attribute :assigned_to => is {user.userable.id}
     if_attribute :assigned2_to => is {user.userable.id}                                                              # Programme Mgr & TPHEP may Show & view reports
   end
   has_permission_on :student_student_discipline_cases, :to => :update, :join_by => :and do # Programme Manager can enter action type (EDIT)
     if_attribute :assigned_to =>  is {user.userable.id}
     if_attribute :action_type => is {nil}
   end
   has_permission_on :student_student_discipline_cases, :to => [:update, :actiontaken, :referbpl], :join_by => :and do 
     if_attribute :assigned2_to => is {user.userable.id}
     if_attribute :action_type => is_not {nil}                                                                             # TPHEP can log action TAKEN if action type==Refer to TPHEP
   end                                                                                                                                      # TODO - edit is still accessible when update accessible(actiontaken, referbpl)
   
   has_permission_on :campus_locations, :to => [:read, :kewpa7]                                          # A staff can read+kewpa7 all location inc. staff & student residences
   
   has_permission_on :events, :to => [:create, :read]                                                             # A staff can read, create but update own
   has_permission_on :events, :to => :update do
     if_attribute :createdby => is {user.userable.id}
   end
   has_permission_on :bulletins, :to => :read                                                                          # A staff can read all bulletins
   #local msg r/a??
   
   has_permission_on :documents, :to => :menu                                                                   # A staff can access Index, but listing restricted to roles / if recepients
   has_permission_on :documents, :to => :read, :join_by => :or do                                       # Any of these staff hv access to Show
     if_attribute :id => is_in {user.document_recepient}
     if_attribute :stafffiled_id => is {user.userable.id}
     if_attribute :prepared_by => is {user.userable.id}
   end
   has_permission_on :documents, :to =>  :update, :join_by => :and do                             # These 3* users may update, unless the file is closed
     if_attribute :closed => is_not {true}
     if_attribute :id => is_in {user.document_recepient}
   end
   has_permission_on :documents, :to =>  :update, :join_by => :and do
     if_attribute :closed => is_not {true}
     if_attribute :stafffiled_id => is {user.userable.id}
   end
   has_permission_on :documents, :to => :update, :join_by => :and do
     if_attribute :closed => is_not {true}
     if_attribute :prepared_by => is {user.userable.id}
   end
   
   #library rules r/a
   has_permission_on :library_books, :to => :read                                                                # A staff can view all books
   has_permission_on :library_librarytransactions, :to => [:analysis_statistic, :analysis_statistic_main, :analysis, :analysis_book, :general_analysis, :general_analysis_ext] 
                                                                                                                                             # A staff can read all - Transaction Analysis & Resource Statistics
   #local messaging & group for local messaging
   has_permission_on :conversations, :to => [:create, :show, :edit_draft, :send_draft, :reply, :trash, :untrash]
   has_permission_on :groups, :to => :menu
   has_permission_on :groups, :to => :show do
     if_attribute :id => is_in {user.members_of_msg_group}
   end
   
 end
   
  role :staff_administrator do
     has_permission_on :staff_staffs, :to => [:manage, :borang_maklumat_staff]
     has_permission_on :staff_staff_attendances, :to =>[:manage, :manager, :actionable, :approval, :manager_admin, :attendance_report, :attendance_report_main, :daily_report, :weekly_report, :monthly_report, :monthly_listing, :monthly_details, :import_excel, :import, :status ]   #29Apr2013-refer routes.rb
     has_permission_on :staff_fingerprints, :to => [:manage, :approval, :index_admin]
     # TODO - addin StaffShift when ready in Ogma #has_permission_on :staff_shifts, :to => :manage
     has_permission_on :staff_positions, :to =>[:manage, :maklumat_perjawatan, :organisation_chart]
     # TODO - add-in Employgrade & Postinfos when ready in Ogma
     # TODO - addin Title & Banks when ready in Ogma
     ###restricted as of in Staff role
     #has_permission_on :staff_staff_appraisals, :to => [:manage, :appraisal_form]    # NOTE : restricted - PPP & PPK + marks by PPP & PPK become viewable 
     #has_permission_on :staff_leaveforstaffs, :to => :manage                                    # restricted - Penyokong & Pelulus                                
     ###
  end
  
  role :finance_unit do
    has_permission_on :staff_travel_claims, :to => [:show, :claimprint] do
      if_attribute :is_submitted => is {true}
    end
    has_permission_on :staff_travel_claims, :to => [:check, :update, :show, :claimprint], :join_by => :and do
      if_attribute :is_submitted => is {true}
      if_attribute :is_returned => is_not {true}
      if_attribute :is_checked => is_not {true}
    end
    # TODO - addin transportgroup & mileagerate when ready in Ogma - has_permission_on [:travel_claims_transport_groups, :travel_claim_mileage_rates], :to => :manage
    has_permission_on [:staff_travel_claim_allowances, :travel_claim_receipts, :travel_claim_logs], :to => :manage
    has_permission_on :staff_training_ptbudgets, :to => :manage
  end

  role :training_manager do
    has_permission_on [:staff_training_ptbudgets, :staff_training_ptcourses, :staff_training_ptschedules], :to => :manage
    has_permission_on :staff_training_ptdos, :to =>:approve
  end
 
  role :training_administration do
    has_permission_on [:staff_training_ptbudgets, :staff_training_ptcourses], :to => :manage
    has_permission_on :staff_training_ptschedules, :to => [:manage, :participants_expenses]
    has_permission_on :staff_training_ptdos, :to => :read 
    has_permission_on :staff_training_ptdos, :to => :update do
      if_attribute :final_approve => is_not {true}
    end
  end
  
  #Group Assets  -------------------------------------------------------------------------------
  role :asset_administrator do
    # TODO - addin Assetcategories when ready in Ogma
    has_permission_on :asset_assets, :to => [:manage, :kewpa2, :kewpa3, :kewpa4, :kewpa5, :kewpa6, :kewpa8, :kewpa13, :kewpa14, :loanables]
    has_permission_on :asset_asset_defects, :to =>[:read, :kewpa9]
    has_permission_on :asset_asset_defects, :to =>[:update, :process2], :join_by => :and do #3nov2013, 21Jan2016
      if_attribute :is_processed => is_not {true}
    end
    has_permission_on :asset_asset_loans, :to => [:read, :create, :lampiran_a] #create added to work with Staffs Modules
    has_permission_on :asset_asset_loans, :to => [:update, :approval] , :join_by => :and do
      if_attribute :is_returned => is_not {true}
    end
    has_permission_on :campus_locations, :to => [:manage, :kewpa7, :kewpa10, :kewpa11]
    has_permission_on :asset_asset_disposals, :to =>[:manage, :kewpa17_20, :kewpa17, :kewpa20, :kewpa16, :kewpa18, :kewpa19, :dispose, :revalue, :verify, :view_close]
    has_permission_on :asset_asset_losses, :to => [:manage, :kewpa28, :kewpa29, :kewpa30, :kewpa31] 
  end

  #OK up to here..... 28Jan2016
  # TODO - lecturer : refer MENU - training_weeklytimetables(menu, read & create + manage & weekly_timetable) (should be restricted to Penyelaras only)
  
 #Group Trainings ------------------------------------------------------------
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
   
   has_permission_on :student_student_attendances, :to => [:manage, :new_multiple, :new_multiple_intake, :create_multiple, :edit_multiple, :update_multiple, :student_attendan_form]
   
   has_permission_on :students, :to => [:read, :borang_maklumat_pelajar] #9Feb2016
   
   has_permission_on :training_programmes, :to => :read
   
   #TRAINING modules
   # TODO - remove below 2 lines once access by module for weeklytimrtable in Catechumen added - to remove those in menu too
   #HACK : INDEX (new) - restricted access except for Penyelaras Kumpulan (diploma & posbasics)
   #has_permission_on :training_weeklytimetables, :to => [:menu, :read, :create]
   
   # TODO - remove below 3 lines once access by module for weeklytimetaable in Catechumen added - to remove those in menu too
   #HACK : INDEX (list+show)- restricted access except for Penyelaras Kumpulan/Ketua Program/Ketua Subjek(+'unit_leader' role)/Administration/creator(prepared_by)
   #HACK : SHOW (+edit) - restricted access UNLESS is_submitted!=true (+submission only allowed for Penyelaras Kumpulan)
   #has_permission_on :training_weeklytimetables, :to => [:manage, :weekly_timetable] 
   
   # TODO lecturer : refer MENU - training_weeklytimetables ENDED here
   
   #OK FROM here..... 29Jan2016 - start
   has_permission_on :training_weeklytimetables, :to => [:read, :personalize_index, :personalize_show, :personalize_timetable, :personalizetimetable] do
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
   
   has_permission_on :training_lesson_plans, :to => :create
   has_permission_on :training_lesson_plans, :to => [:read, :lesson_plan, :lesson_report] do
     if_attribute :lecturer => is {user.userable_id}
   end
   has_permission_on :training_lesson_plans, :to => :update, :join_by => :and do
     if_attribute :lecturer => is {user.userable_id}
     if_attribute :is_submitted => is_not {true}
   end
   has_permission_on :training_lesson_plans, :to => [:lessonplan_reporting, :update], :join_by => :and do
     if_attribute :lecturer => is {user.userable_id}
     if_attribute :is_submitted => is {true}
     if_attribute :hod_approved => is {true}
     if_attribute :report_submit => is_not {true}
   end
   #OK until here..... 29Jan2016
   
   #EXAMINATION modules
   #moved examination modules to role - exam_administration
   has_permission_on :exam_examquestions, :to => [:menu, :read, :index, :create]
   has_permission_on :exam_examquestions, :to => :update do
     if_attribute :programme_id => is_in {user.lecturers_programme}
   end
   # TODO - fix below, temp use above
#    has_permission_on :exam_examquestions, :to =>:update, :join_by => :and do
#      if_attribute :creator_id => is {user.userable.id}
#      if_attribute :qstatus => is {"New"}
#    end
#    #any other lecturer from the same programme can be an EDITOR
#    has_permission_on :exam_examquestions, :to =>:update, :join_by => :and do
#      if_attribute :creator_id => is_not {user.userable.id}
#      if_attribute :qstatus => is {"Submit"}
#    end
#    #if EDITOR hold record first, for later editing, must be the same person
#    has_permission_on :exam_examquestions, :to => :update, :join_by => :and do
#      if_attribute :editor_id => is {user.userable.id}
#      if_attribute :qstatus => is {"Editing"}
#    end
#    #HOD can approve although not assigned - role:programme_manager
#    has_permission_on :exam_examquestions, :to => :manage do
#      if_attribute :approver_id => is {user.userable.id}
#    end
#    #Ready for approval - HOD classify as Re-Edit, return to editor
#    has_permission_on :exam_examquestions, :to =>:update, :join_by => :and do
#      if_attribute :editor_id => is {user.userable.id}
#      if_attribute :qstatus => is {"Re-Edit"}
#    end
   
  end
 
  #OK - 29Jan2016 - this role + programme mgr (exam parts) works fine as of latest Nov 2015-Jan 2016 accepted unless stated below..
  role :exam_administration do
    has_permission_on [:exam_exams, :exam_exam_templates, :exam_exammarks, :exam_grades], :to => [:menu, :read, :index, :create]
    has_permission_on :exam_examresults, :to => [:menu, :read, :index2, :create, :update, :destroy, :show2, :examination_slip, :show3, :examination_transcript, :results]   
    has_permission_on :exam_examanalyses, :to => [:menu, :read, :create]
    has_permission_on :exam_exam_templates, :to =>[:manage] do
      if_attribute :created_by => is {user.id}
    end
    has_permission_on :exam_exams, :to =>[:manage ,:exampaper, :question_selection] do
      if_attribute :created_by => is {user.userable.id}
    end
    has_permission_on :exam_exams, :to => :exampaper do
      if_attribute :subject_id => is_in {user.lecturers_programme_subject}
    end
    has_permission_on :exam_exammarks, :to =>[:update, :delete, :edit_multiple, :update_multiple, :new_multiple, :create_multiple] do
      if_attribute :exam_id => is_in {user.exams_of_programme}
    end
    #pending - just in case other programme's grade appear in current programme index page?
    has_permission_on :exam_grades, :to => [:update, :delete, :edit_multiple, :update_multiple, :new_multiple, :create_multiple] do
      if_attribute :id => is_in {user.grades_of_programme}
    end
    has_permission_on :exam_examresults, :to =>[ :edit, :update, :delete] do
      if_attribute :programme_id => is_in {user.lecturers_programme2}
    end
    #has_permission_on :exam_evaluate_courses, :to => :manage - evaluation supposed by student - lecturer being evaluate shouldn't hv EDIT access
    has_permission_on :exam_evaluate_courses, :to =>[:index, :show, :courseevaluation] do
      if_attribute :staff_id => is {user.userable.id}
    end
    has_permission_on :exam_examanalyses, :to => [:edit, :update, :delete, :analysis_data] do
      if_attribute :exam_id => is_in {user.by_programme_exams}  
    end
  end

  #28Dec2015- confirmed by EN Ahmad - access for Examination modules restricted ONLY for Exam Admin (except for Programme Mgr : Examresult by Prog, Examanalysis, Examquestions & Course Evaluation)
  role :programme_manager do
    has_permission_on :exam_examquestions, :to => :manage
    #has_permission_on [:exam_exam_templates, :exam_grades], :to => [:menu, :read]
    #has_permission_on :exam_exams, :to => [:menu, :read, :exampaper, :question_selection] #[:manage, :exampaper, :question_selection]
    #has_permission_on :exam_exammarks, :to => [:menu, :read] #[:manage, :edit_multiple, :update_multiple, :new_multiple, :create_multiple]
    has_permission_on :exam_evaluate_courses, :to => [:read, :courseevaluation, :evaluation_report] do
      if_attribute :course_id => is_in {user.evaluations_of_programme}
    end
    has_permission_on :exam_examresults, :to => [:menu, :read]#, :index2, :show2, :examination_slip, :show3, :examination_transcript]# :create, :update,  :destroy]   
    has_permission_on :exam_examanalyses, :to => [:menu, :read] do
      if_attribute :exam_id => is_in {user.by_programme_exams}  
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
    has_permission_on [:training_programmes, :training_academic_sessions, :training_intakes, :training_timetables, :training_topicdetails], :to => :manage
    has_permission_on :training_lesson_plans, :to => [:read, :lesson_plan, :lesson_report, :delete] do
      if_attribute :lecturer => is_in {user.unit_members}
    end
    has_permission_on :training_lesson_plans, :to =>:update, :join_by => :and do
      if_attribute :lecturer => is_in {user.unit_members}
      if_attribute :is_submitted => is {true}
      if_attribute :hod_approved => is_not {true}
    end
    has_permission_on :training_lesson_plans, :to => [:lessonplan_reporting, :update], :join_by  => :and do
      if_attribute :lecturer => is {user.userable_id}
      if_attribute :is_submitted => is {true}
      if_attribute :hod_approved => is {true}
      if_attribute :report_submit => is {true}
    end
  end
  
 #Group Library   -------------------------------------------------------------------------------

  role :librarian do
    has_permission_on :library_books, :to => [:manage, :import_excel, :download_excel_format, :import]
    has_permission_on :library_librarytransactions, :to => [:manage, :extending, :returning, :check_status, :analysis_statistic, :analysis_statistic_main, :analysis, :analysis_book, :general_analysis, :general_analysis_ext]
    has_permission_on :students, :to => [:read, :borang_maklumat_pelajar]
  end

  #Group Student --------------------------------------------------------------------------------
  role :student do
      has_permission_on :exam_evaluate_courses, :to => [:index, :create]
      has_permission_on :exam_evaluate_courses, :to => [:read, :update, :courseevaluation] do
        if_attribute :student_id => is {user.userable.id}
      end
      has_permission_on :students, :to => [:update, :show, :borang_maklumat_pelajar] do 
        if_attribute :id => is {user.userable.id}
      end
      has_permission_on :student_leaveforstudents, :to =>[:menu, :create]
      has_permission_on :student_leaveforstudents, :to => [:read, :slip_pengesahan_cuti_pelajar] do
        if_attribute :student_id => is {user.userable.id}
      end
      has_permission_on :student_leaveforstudents, :to => :update do
        if_attribute :student_id => is {user.userable.id}
        if_attribute :studentsubmit => is_not {true}
      end
  end
  
  role :student_administrator do
     has_permission_on :students, :to => [:manage, :borang_maklumat_pelajar, :reports, :student_report, :ethnic_listing, :kumpulan_etnik, :kumpulan_etnik_main, :kumpulan_etnik_excel,:import, :import_excel, :download_excel_format, :students_quantity_sponsor, :students_quantity_report] 
  end
  
  role :disciplinary_officer do
    has_permission_on :student_student_discipline_cases, :to => [:menu, :read, :delete, :reports, :discipline_report, :anacdotal_report, :actiontaken, :referbpl]
    has_permission_on :student_student_discipline_cases, :to => :update do
      if_attribute :status => is_not {"Closed"}                                                            # TODO - Edit still accessible although status is referbpl
    end 
    has_permission_on :student_student_counseling_sessions, :to => :feedback_referrer do
      if_attribute :case_id =>  is_not {nil}
    end
    has_permission_on [:students, :student_student_attendances], :to => :read
  end

  role :student_counsellor do
    has_permission_on :student_student_counseling_sessions, :to => [:manage, :feedback_referrer]
    has_permission_on [:students, :student_student_attendances], :to => :read
  end
  
  #Group Location --------------------------------------------------------------------------------
  role :facilities_administrator do
    has_permission_on :campus_locations, :to => [:manage, :kewpa7, :kewpa10, :kewpa11, :statistic_level, :census_level2, :statistic_block] 
    has_permission_on :campus_location_damages, :to =>[:manage, :index_staff, :damage_report, :damage_report_staff]
    has_permission_on :student_tenants, :to => [:manage, :index_staff, :reports,:census_level, :room_map, :room_map2, :statistics, :return_key, :return_key2, :census, :tenant_report, :tenant_report_staff, :laporan_penginapan, :laporan_penginapan2]
  end
  role :warden do
    has_permission_on :campus_locations, :to => [:read, :kewpa7] #:core - NOTE - kewpa7 visible to all (sticked on wall)
    has_permission_on :student_tenants, :to => :read
    #all wardens have access - [relationship: second_approver, FK: staff_id2, page: approve_warden]
    has_permission_on :student_leaveforstudents, :to => [:index, :menu, :create, :show, :update, :approve_warden] do
      if_attribute :studentsubmit => true
    end
    has_permission_on :students, :to => :read
    has_permission_on :student_student_attendances, :to => :read                                                     #lecturer role - shall override this rule
    has_permission_on :student_student_counseling_sessions, :to => [:read, :feedback_referrer] 
    has_permission_on :student_student_discipline_cases, :to => [:menu, :read]
  end
  
  role :unit_leader do
    has_permission_on :staff_training_ptdos, :to => :read do
      if_attribute :staff_id => is_in {user.unit_members}
    end
    has_permission_on :staff_training_ptdos, :to => :update, :join_by => :and do
      if_attribute :staff_id => is_in {user.unit_members}
      if_attribute :unit_approve => is_not {true}
    end
    has_permission_on :staff_staff_attendances, :to => [:approval, :update, :show] do                #25Jan2016-approve(update) - lateness / late return & show Fingerprint
      if_attribute :thumb_id => is_in {user.unit_members_thumb}
    end
    has_permission_on :training_programmes, :to => :manage, :join_by => :and do                     # only for Ketua Subjek Asas
      if_attribute :name => is {user.userable.positions.first.unit}
      if_attribute :course_type => is {"Commonsubject"}
    end
  end
  
  role :administration_staff do
    #access for Timbalan Pengarah (Pengurusan) & Pengarah
    has_permission_on :staff_training_ptdos, :to => :read, :join_by => :or do
      if_attribute :staff_id => is_in {user.admin_subordinates}
      if_attribute :staff_id => is_in {user.director_subordinates}
    end
    has_permission_on :staff_training_ptdos, :to => :update, :join_by => :and do                        # act as Dept Approver
      if_attribute :staff_id => is_in {user.admin_subordinates}
      if_attribute :unit_approve => is {true}
      if_attribute :dept_approve => is_not {true}
    end
    has_permission_on :staff_training_ptdos, :to => :update, :join_by => :and do                        # act a Director
      if_attribute :staff_id => is_in {user.director_subordinates}
      if_attribute :unit_approve => is {true}
      if_attribute :dept_approve => is {true}
      if_attribute :final_approve => is_not {true}
    end
    #access for Timbalan Pengarah (Pengurusan) & Pengarah(Timbalans+Ketua2 Programs)
    has_permission_on :staff_staff_attendances, :to => [:approval, :update, :show] do
      if_attribute :thumb_id => is_in {user.admin_unitleaders_thumb}
    end
    has_permission_on :staff_staff_fingerprints, :to => :approval do
      if_attribute :thumb_id => is_in {user.admin_unitleaders_thumb}
    end
  end
  
  role :e_filing do
    has_permission_on :cofiles, :to => :manage
    has_permission_on :documents, :to => [:manage, :document_report]
  end
  
  role :guest do
    has_permission_on :users, :to => [:link, :update]
    #has_permission_on :users, :to => :create
    #has_permission_on :library_books, :to => :read   
    #hide ALL modules from guest first --> 14 March 2015 & temporary add 3 items for permission for warden library_books, assets & students
    #coz roles assign for guest - accessible to user WITHOUT LOGIN due to firefox/Ie - unsupported version (old version)
  end
  
  #OK - 29Jan2016 until here************************************************

  #Access per module 
  ## first trial - access by module - sample
  #role :staffs_module do
  #  has_permission_on :student_student_discipline_cases, :to =>[ :index, :read]
  #end
  #(CRUD/A), (R/A), (RU/A), (CRUD/O)
  #Admin : can do everything (CRUD/A)
  #Viewer(Read) : can list, print & reports only (R/A)
  #User : can view everything & update data (RU/A)
  #Member(Owner) : should only see his own record & be able to edit it (CRUD/O)
  #####start of Staff Module#######################################
  #1)OK - all 4 - 4Feb2016 ** NOTE - local messaging & groups added into Staff modules - all access as of 'Staff' role
  role :staffs_module_admin do
    has_permission_on :staff_staffs, :to => [:manage, :borang_maklumat_staff] #1) OK - if read (for all), Own data - can update / pdf, if manage also OK
  end
  role :staffs_module_viewer do
    has_permission_on :staff_staffs, :to => [:read, :borang_maklumat_staff]
  end
  role :staffs_module_user do
    has_permission_on :staff_staffs, :to => [:read, :update, :borang_maklumat_staff]
  end
  role :staffs_module_member do
    has_permission_on :staff_staffs, :to => [:read, :update, :borang_maklumat_staff] do
      if_attribute :id => is {user.userable.id}
    end
  end
  
  #2)OK - all 4 - 4Feb2016
  role :positions_module_admin do
     has_permission_on :staff_positions, :to => [:manage, :organisation_chart]
  end
  role :positions_module_viewer do
     has_permission_on :staff_positions, :to => [:read, :organisation_chart]
  end
  role :positions_module_user do
     has_permission_on :staff_positions, :to => [:read, :update, :organisation_chart]
  end
  role :positions_module_member do
    has_permission_on :staff_positions, :to =>  [:read, :update, :organisation_chart] do
      if_attribute :staff_id => is {user.userable.id}
    end
  end
  
  #3)OK - all 4 - 4Feb2016
  #NOTE - a) Staff Attendance should come with Fingerprints, StaffShifts
  role :staff_attendances_module_admin do
    has_permission_on :staff_staff_attendances, :to =>[:manage, :manager, :manager_admin, :approval, :actionable, :status, :attendance_report, :attendance_report_main, :daily_report, :weekly_report, :monthly_report, :monthly_listing, :monthly_details] 
  end
  role :staff_attendances_module_viewer do
    #1) OK, but if READ only - can only read attendance list for all staff +manage own lateness/early (MANAGER) - as this is default for all staff UNLESS if MANAGE given.
    has_permission_on :staff_staff_attendances, :to => [:read, :manager, :manager_admin, :status, :attendance_report, :attendance_report_main, :daily_report, :weekly_report, :monthly_report, :monthly_listing, :monthly_details]
  end
  role :staff_attendances_module_user do 
    has_permission_on :staff_staff_attendances, :to => [:read, :update, :manager, :manager_admin, :approval, :actionable, :status, :attendance_report, :attendance_report_main, :daily_report, :weekly_report, :monthly_report, :monthly_listing, :monthly_details]
  end
  role :staff_attendances_module_member do
    #own records
    has_permission_on [:staff_staff_attendances], :to => :manager                                   
    has_permission_on :staff_staff_attendances, :to => [:show, :update] do                        # show & update - to enter reason
      if_attribute :thumb_id => is {user.userable.thumb_id}
    end
    #own (approver) #refer Administration role(Timbalans) & Programme Manager
    #own (approver) - refer Unit Leader role
    has_permission_on :staff_staff_attendances, :to => [:approval, :update, :show], :join_by => :or do
      if_attribute :thumb_id => is_in {user.admin_unitleaders_thumb}
      if_attribute :thumb_id => is_in {user.unit_members_thumb}
    end
  end
  
  #4-OK - all 4 - 4Feb2016
  #4-OK - for read, but manage - requires role: MANAGE for staff_attendances to be activated as well
  #restriction - INDEX - @fingerprints restricted to own record, @approvefingerprints restricted to unit members, BUT INDEX_ADMIN OK
  role :fingerprints_module_admin do
    has_permission_on :staff_fingerprints, :to =>[:manage, :approval, :index_admin]
  end
  role :fingerprints_module_viewer do
    has_permission_on :staff_fingerprints, :to => [:read, :index_admin]
  end
  role :fingerprints_module_user do
    has_permission_on :staff_fingerprints, :to => [:read, :index_admin, :approval, :update]
  end
  role :fingerprints_module_member do
    #own record
    has_permission_on :staff_fingerprints, :to => [:read, :update] do                                   
      if_attribute :thumb_id => is {user.userable.thumb_id}
    end
    #own (approver) - Timbalans / HOD - refer Administration Staff roles
    has_permission_on :staff_fingerprints, :to => [:read, :index_admin, :approval, :update] do
      if_attribute :thumb_id => is_in {user.admin_unitleaders_thumb}
    end
  end
  
  #5-OK - all 4 - 4-5Feb2016
  #5-OK - for read, but for manage with restrictions as of super admin (PYD, PPP, PPK)
  role :staff_appraisals_module_admin do
     has_permission_on :staff_staff_appraisals, :to => [:manage, :appraisal_form]
  end
  role :staff_appraisals_module_viewer do
     has_permission_on :staff_staff_appraisals, :to => [:read, :appraisal_form] 
  end
  role :staff_appraisals_module_user do
    has_permission_on :staff_staff_appraisals, :to => [:read, :update, :appraisal_form]
  end
  role :staff_appraisals_module_member do
    #own record 
    has_permission_on :staff_staff_appraisals, :to => :create                                                # A staff can create appraisal
    has_permission_on :staff_staff_appraisals, :to => [:show, :appraisal_form] do                # but cannot see marking parts
      if_attribute :staff_id => is {user.userable.id}
    end
    has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do              # can enter SKT, when skt not yet submitted
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :is_skt_submit => is_not {true}
    end
    has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do              # can review SKT, when skt endorsed, but review/report not done
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :is_skt_endorsed => is {true}
      if_attribute :is_skt_pyd_report_done => is_not {true}
    end
    has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do              # can enter Training Needed, when skt PPP report is done & submit 4 evaluation
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :is_skt_ppp_report_done => is {true}
      if_attribute :is_submit_for_evaluation => is_not {true}
    end
    #own (approver - PPP or PPK)
    has_permission_on :staff_staff_appraisals, :to =>[:read, :appraisal_form], :join_by => :or do  # PPP & PPK have read access
      if_attribute :eval1_by => is {user.userable.id}
      if_attribute :eval2_by => is {user.userable.id}
    end
    #PPP
    has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do             # PPP can endorse SKT
      if_attribute :eval1_by => is {user.userable.id}
      if_attribute :is_skt_submit => is {true}
      if_attribute :is_skt_endorsed => is_not{true}
    end
    has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do             # PPP can complete reviewed SKT
      if_attribute :eval1_by => is {user.userable.id}
      if_attribute :is_skt_pyd_report_done => is {true}
      if_attribute :is_skt_ppp_report_done => is_not {true}
    end
    has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do             # PPP can evaluate when PYD submit 4 evaluation
      if_attribute :eval1_by => is {user.userable.id}
      if_attribute :is_submit_for_evaluation => is {true}
      if_attribute :is_submit_e2 => is_not {true}
    end
    #PPK
    has_permission_on :staff_staff_appraisals, :to => :update, :join_by => :and do             # PPK can evaluate when evaluation by PPP was done
      if_attribute :eval2_by => is {user.userable.id}
      if_attribute :is_submit_e2 => is {true}
      if_attribute :is_complete => is_not {true}
    end
  end
  
  #6-OK - all 4 - 5Feb2016
  #6-OK - for read, but for manage with restrictions as of super admin (processing_level_1, processing_level_2: penyokong, pelulus)
  role :staff_leaves_module_admin do
     has_permission_on :staff_leaveforstaffs, :to => [:manage, :processing_level_1, :processing_level_2]
  end
  role :staff_leaves_module_viewer do
     has_permission_on :staff_leaveforstaffs, :to =>:read
  end
  role :staff_leaves_module_user do
     has_permission_on :staff_leaveforstaffs, :to =>[:read, :update]
  end
  role :staff_leaves_module_member do
    #own record
    has_permission_on :staff_leaveforstaffs, :to => :create                                                                       # A staff can register for leave
    has_permission_on :staff_leaveforstaffs, :to => :read do                                                                    # Staff can view his leave 
      if_attribute :staff_id => is {user.userable.id}
    end
    has_permission_on :staff_leaveforstaffs, :to => :delete, :join_by => :and do                                      # Staff can delete as long as it is not processed yet
      if_attribute :staff_id => is {user.userable.id}                                                                                    # NOTE - edit page is hide
      if_attribute :approval1 => is_not {true}
    end
    #own (approver - Penyokong)
    has_permission_on :staff_leaveforstaffs, :to => :read, :join_by => :or do                                            # Penyokong and pelulus can view staff leave
      if_attribute :approval1_id => is {user.userable.id}
      if_attribute :approval2_id => is {user.userable.id}
    end
    has_permission_on :staff_leaveforstaffs, :to => [:processing_level_1, :update], :join_by => :and do  # Penyokong can update as long as not process by Pelulus
      if_attribute :approval1_id => is {user.userable.id}
      if_attribute :approval1 => is_not {true}
    end
    #own (approver - Pelulus)
    has_permission_on :staff_leaveforstaffs, :to => [:processing_level_2, :update], :join_by => :and do   # Pelulus can approve leave
      if_attribute :approval2_id => is {user.userable.id}
      if_attribute :approval1 => is {true}
      if_attribute :approver2 => is_not {true}
    end
  end
  
  #7-OK - 3/4 (Admin, Viewer & User), Member : applicable only for applicant & final approver (To assign user with Finance Check, use 'Finance Unit' role instead, which will disable all type of module access for Travel Claims Module & Training Budget Module)
  # NOTE Travel Claim should come with Travel Request
  role :travel_claims_module_admin do
    has_permission_on :staff_travel_claims, :to => [:manage, :check, :approve, :claimprint]
  end
  role :travel_claims_module_viewer do
    has_permission_on :staff_travel_claims, :to => [:read, :claimprint] 
  end
  role :travel_claims_module_user do
    has_permission_on :staff_travel_claims, :to => [:check, :approve, :claimprint]
  end
  role :travel_claims_module_member do
    #own records (as role staff)
    has_permission_on :staff_travel_claims, :to => [:menu, :create]                                              # A staff can register Travel Claims
    has_permission_on :staff_travel_claims, :to => [:read, :claimprint], :join_by => :or do            # Applicant / Approver may show / pdf (Finance - refer role)
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :approved_by => is {user.userable.id}
    end
    has_permission_on :staff_travel_claims, :to => :update, :join_by => :and do                          # Applicant may update unless submitted
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :is_submitted => is_not {true}
    end
    has_permission_on :staff_travel_claims, :to => :update, :join_by => :and do                          # Applicant may update returned application (by FInance Unit)
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :is_checked => is {false}
      if_attribute :is_returned => is {true}
    end
    #own (final approval-as role staff)
    has_permission_on :staff_travel_claims, :to => [:approve, :update], :join_by => :and do        # Approver may approve if not yet approve
      if_attribute :approved_by => is {user.userable.id}
      if_attribute :is_approved => is_not {true}
    end
    has_permission_on [:staff_travel_claim_allowances, :travel_claim_receipts, :travel_claim_logs], :to => :manage
    
  end
 
  #8-OK prev update for Manage & Read, (BUT 4 latest update ONLY MEMBER is OK - 5Feb2016)
  # TODO TODO TODO- To confirm / discuss / revise upon completion of these Auth Rules (access by module : Admin, Viewer, User & Member)
  # NOTE - Restriction as of in Catechumen - INDEX page shall personalize to current user, containing 2 listing ie. 'in_need_of_approval' & 'my_travel_request',
  #whereas Admin, Viewer & User requires listing for ALL travel requests records.????then what's the use of hvg these 3??? Member already enough! to discuss!
  role :travel_requests_module_admin do
    has_permission_on :staff_travel_requests, :to => [:manage, :travel_log_index, :travel_log, :approval, :status_movement]
  end                                                                                                                                                     # Admin - can do everything (restrictions: own recs only)
  role :travel_requests_module_viewer do
    has_permission_on :staff_travel_requests, :to => [:read, :travel_log_index, :status_movement] 
  end                                                                                                                                                     # Viewer - can view everything (restrictions : own recs only)
  role :travel_requests_module_user do
    has_permission_on :staff_travel_requests, :to => [:approve, :approval, :travel_log, :travel_log_index, :status_movement] # NOTE - approve : Read+Update
  end                                                                                                                                                     # User - can Read & Update (restrictions : own recs only)
  role :travel_requests_module_member do
    has_permission_on :staff_travel_requests, :to => [:menu, :create, :travel_log_index]
    has_permission_on :staff_travel_requests, :to => [:read, :status_movement], :join_by => :or do
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :hod_id => is {user.userable.id}
    end
    has_permission_on :staff_travel_requests, :to => :update, :join_by => :and do
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :is_submitted => is_not {true}
    end
    has_permission_on :staff_travel_requests, :to => [:approval, :update], :join_by => :and do   # TODO - HOD must not hv access to EDIT request, only APPROVAL
      if_attribute :hod_id => is {user.userable.id}
      if_attribute :is_submitted => is {true}
    end
    has_permission_on :staff_travel_requests, :to => [:travel_log, :update], :join_by => :and do  # TODO - Applicant must not hv access to EDIT request, only TRAVEL LOG
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :hod_accept => is {true}
    end
  end

  
  
  # TODO - 'Training Courses Module' & 'Training Schedule Module' - User & Member are similar ?, may have TO DISABLE one
  
  
  #9-OK - 2/4 OK (Manage & User) whereas Viewer & Member access are similar? - 6Feb2016
  # NOTE - for access by 'Training Budget Module'/'Training Courses Module' (Admin/Viewer/User/Member), must activate at least 'Training Attendance Module'(Member/Viewer)
  # NOTE 'Training Budget Module' - Viewer & Member access are similar?, Member (disable) - as records has no ownership data
  role :training_budget_module_admin do
     has_permission_on :staff_training_ptbudgets, :to => :manage
  end
  role :training_budget_module_viewer do
     has_permission_on :staff_training_ptbudgets, :to => :read
  end
  role :training_budget_module_user do
     has_permission_on :staff_training_ptbudgets, :to => [:read, :update]
  end
#   role :training_budget_module_member do
#      has_permission_on :staff_training_ptbudgets, :to => :read
#   end
  
  #10 - 2/4 OK (Manage & Viewer) 
  # NOTE - for access by 'Training Budget Module'/'Training Courses Module' (Admin/Viewer/User/Member), must activate at least 'Training Attendance Module'(Member/Viewer)
  # NOTE 'Training Courses Module' - Viewer & Member access are similar?, Member (disable) - as records has no ownership data
  #10-OK, in show - link 'schedule a course' requires manage for ptschedules
  role :training_courses_module_admin do
     has_permission_on :staff_training_ptcourses, :to =>:manage
  end
  role :training_courses_module_viewer do
     has_permission_on :staff_training_ptcourses, :to =>:read
  end
  role :training_courses_module_user do
     has_permission_on :staff_training_ptcourses, :to =>[:read, :update]
  end
#   role :training_courses_module_member do
#      has_permission_on :staff_training_ptcourses, :to =>[:read, :update]
#   end
  
  #11 - 2/4 OK (Manage & Viewer) TODO User & Member access are similar? - 6Feb2016
  #11-OK - note pending 'Apply for Training' menu link
  role :training_schedule_module_admin do
     has_permission_on :staff_training_ptschedules, :to => [:manage, :participants_expenses]
  end
  role :training_schedule_module_viewer do
     has_permission_on :staff_training_ptschedules, :to => [:read, :participants_expenses]
  end
  role :training_schedule_module_user do
     has_permission_on :staff_training_ptschedules, :to => [:read, :participants_expenses, :update]
  end
  role :training_schedule_module_member do
     has_permission_on :staff_training_ptschedules, :to => [:read, :participants_expenses, :update]
  end 
  
  #12-OK, but 'Show Total Days' & 'Training Report' restricted to own record only.
  #12 - 3/4 OK (Admin, Viewer & User)
  role :training_attendance_module_admin do
    #asal - tested OK - Admin : has_permission_on :staff_training_ptdos, :to => [:manage, :approve]
    has_permission_on :staff_training_ptdos, :to => [:create, :read, :show_total_days, :training_report, :delete]
    has_permission_on :staff_training_ptdos, :to => :update, :join_by => :and do                        # act as Dept Approver
      if_attribute :unit_approve => is {true}
      if_attribute :dept_approve => is_not {true}
    end
    has_permission_on :staff_training_ptdos, :to => :update, :join_by => :and do                        # act as a Director
      if_attribute :unit_approve => is {true}
      if_attribute :dept_approve => is {true}
      if_attribute :final_approve => is_not {true}
    end
    has_permission_on :staff_training_ptdos, :to => :update, :join_by => :and do                        # act as a Unit Leader / Programme Manager
      if_attribute :unit_approve => is_not {true}
    end
  end
  role :training_attendance_module_viewer do
     has_permission_on :staff_training_ptdos, :to => [:read, :show_total_days, :training_report]
  end
  role :training_attendance_module_user do
    #same as Admin, except for CREATE & DELETE
    has_permission_on :staff_training_ptdos, :to => [:read, :show_total_days, :training_report]
    has_permission_on :staff_training_ptdos, :to => :update, :join_by => :and do                        # act as Dept Approver
      if_attribute :unit_approve => is {true}
      if_attribute :dept_approve => is_not {true}
    end
    has_permission_on :staff_training_ptdos, :to => :update, :join_by => :and do                        # act as a Director
      if_attribute :unit_approve => is {true}
      if_attribute :dept_approve => is {true}
      if_attribute :final_approve => is_not {true}
    end
    has_permission_on :staff_training_ptdos, :to => :update, :join_by => :and do                        # act as a Unit Leader / Programme Manager
      if_attribute :unit_approve => is_not {true}
    end
  end
   role :training_attendance_module_member do
    #own records 
    has_permission_on :staff_training_ptdos, :to => :create                                                         # A staff can register for training session
    has_permission_on :staff_training_ptdos, :to => [:read, :show_total_days, :training_report, :delete] do
      if_attribute :staff_id => is {user.userable.id}                                                                        # but onle see his own registrations
    end
    # NOTE - 'Training Attendance Module' (Member) should come with Programme Manager role(Dept Approval-Academician section) in order to get Dept Approval (Academics) works,
    # NOTE - 'Training Attendance Module' (Member) is not available for Unit Approval(Management) & Department Approval(Timb Pengarah Pengurusan) & Final Approval(Director) - use 'Administration Staff' role instead. 'Administration Staff' role already covers these 3 positions functions in staff Training Attendance
  end
  #####end for STAFF modules#######################################
  #####starts of Student's related modules###############################
  #13-OK, but note - lecturers & warden has related access rules too, use other user for checking
  #13 - 3/4 OK (Admin, Viewer, User)
  role :student_leaves_module_admin do
     has_permission_on :student_leaveforstudents, :to => [:manage, :approve_coordinator, :approve_warden, :slip_pengesahan_cuti_pelajar, :studentleave_report]
     # [:manage, :approve, :studentleave_report, :slip_pengesahan_cuti_pelajar] 
  end
  role :student_leaves_module_viewer do
     has_permission_on :student_leaveforstudents, :to => [:read, :slip_pengesahan_cuti_pelajar, :studentleave_report]
  end
  role :student_leaves_module_user do
     has_permission_on :student_leaveforstudents, :to => [:read, :approve_coordinator, :approve_warden, :update, :slip_pengesahan_cuti_pelajar, :studentleave_report]
  end
  role :student_leaves_module_member do
    #own records (student)
    has_permission_on :student_leaveforstudents, :to =>[:menu, :create]
    has_permission_on :student_leaveforstudents, :to => [:read, :slip_pengesahan_cuti_pelajar] do
      if_attribute :student_id => is {user.userable.id}
    end
    # NOTE approver (Warden & Lecturer[penyelaras]) not applicable, activate Warden and / or Lecturer role accordingly
  end

  #14-OK, but note - in controller, ':attribute_check => true' only applicable for show, edit, update & destroy of SINGLE record
  #14 - 3/4 OK (Admin, Viewer, User) OK - 8Feb2016
  role :student_attendances_module_admin do
    has_permission_on :student_student_attendances, :to =>[:manage, :student_attendan_form, :edit_multiple, :update_multiple]
  end
  role :student_attendances_module_viewer do
    has_permission_on :student_student_attendances, :to =>[:read, :student_attendan_form]
  end
  role :student_attendances_module_user do
    has_permission_on :student_student_attendances, :to =>[:read, :update, :edit_multiple, :update_multiple, :student_attendan_form]
  end
# NOTE - DISABLE(in EACH radio buttons - studentown[1].disabled=true) as the one & only owner of this module is Lecturer, use 'Lecturer' role instead.
#   role :student_attendances_module_member do
#      has_permission_on :student_student_attendances, :to => [:create, :new_multiple, :new_multiple_intake] do
#        if_attribute :student_id => is_in {Student.where(course_id: Programme.where(name: user.userable.positions.first.unit).first.id).pluck(:id)}
#      end
#      has_permission_on :student_student_attendances, :to => [:update, :create_multiple, :edit_multiple, :update_multiple, :student_attendan_form] do
#        if_attribute :weeklytimetable_details_id => is_in {WeeklytimetableDetail.where(lecturer_id: user.userable.id).pluck(:id)}
#      end
#   end
  
  #15-OK 
  #15 - 3/4 (Admin, Viewer, User) OK - 8Feb2016
  role :student_counseling_module_admin do
     has_permission_on :student_student_counseling_sessions, :to => [:manage, :feedback_referrer] 
  end
  role :student_counseling_module_viewer do
     has_permission_on :student_student_counseling_sessions, :to =>[:read, :feedback_referrer]
  end
  role :student_counseling_module_user do
     has_permission_on :student_student_counseling_sessions, :to =>[:read, :update, :feedback_referrer]
  end
# NOTE - DISABLE(in EACH radio buttons - studentown[2].disabled=true) as the one & only owner of this module is Counsellor, use 'Student Counsellor' role instead.  
#   role :student_counseling_module_member do
#   end

  #16-OK - 1) for READ & Manage, note 'discipline_report' & 'anacdotal_report' accessibility is same as INDEX pg, 2) New - open for all staff
  #3) additional report - fr menu, Students | Reporting -- (i) Discipline Case Listing by Students, (ii) Student Discipline Case Listing
  role :student_discipline_module_admin do
     has_permission_on :student_student_discipline_cases, :to => [:manage, :actiontaken, :referbpl,:reports, :discipline_report, :anacdotal_report]
  end
  role :student_discipline_module_viewer do
     has_permission_on :student_student_discipline_cases, :to => [:menu, :read, :reports, :discipline_report] 
  end
  role :student_discipline_module_user do
     has_permission_on :student_student_discipline_cases, :to => [:menu, :read, :update, :actiontaken, :referbpl,:reports, :discipline_report, :anacdotal_report] 
  end
  # NOTE workable SELECTION of auth rules for members: (positions data must complete) 
  #1) Reporter, Programme Manager & TPHEP - 'Staff' role / Student Discipline Module Member
  #2) Discipline Officer - must activate 'Disciplinary Officer 'role
  role :student_discipline_module_member do
    #own records
    has_permission_on :student_student_discipline_cases, :to => [:menu, :create]                     # A staff can register discipline case
    has_permission_on :student_student_discipline_cases, :to => :delete, :join_by => :and do   # reporter can remove case before action type entered by Programme Mgr
      if_attribute :reported_by => is {user.userable.id}
      if_attribute :action_type => is {nil}
    end
    has_permission_on :student_student_discipline_cases, :to => :read do                                 # reporter have access to read cases
      if_attribute :reported_by => is {user.userable.id}
    end
    #own (Programme Manager & TPHEP)
    has_permission_on :student_student_discipline_cases, :to => [:read, :discipline_report, :anacdotal_report], :join_by => :or do        
      if_attribute :assigned_to => is {user.userable.id}
      if_attribute :assigned2_to => is {user.userable.id}                                                              # Programme Mgr & TPHEP may Show & view reports
    end
    has_permission_on :student_student_discipline_cases, :to => :update, :join_by => :and do # Programme Manager can enter action type (EDIT)
      if_attribute :assigned_to =>  is {user.userable.id}
      if_attribute :action_type => is {nil}
    end
    has_permission_on :student_student_discipline_cases, :to => [:update, :actiontaken, :referbpl], :join_by => :and do 
      if_attribute :assigned2_to => is {user.userable.id}
      if_attribute :action_type => is_not {nil}                                                                             # TPHEP can log action TAKEN if action type==Refer to TPHEP
    end 
  end
  
  #Modules : Tenants & Locations
  #laporan_penginapan(PDF)==statistic_level(xls),  laporan_penginapan2(PDF)==statistic_block(xls), census_level(haml)->census(PDF)==census_level2(xls)
 
  #17-OK - but note read/manage - xls links accessible via INDEX pg, when index accessible(index.xls)
  #17 - 3/4 OK(Admin, Viewer, User) - 9Feb2016
  role :tenants_module_admin do
     has_permission_on :student_tenants, :to =>[:manage, :index_staff, :tenant_report, :tenant_report_staff, :room_map,:room_map2, :return_key, :return_key2, :reports, :statistics, :laporan_penginapan, :laporan_penginapan2, :census, :census_level]
  end
  role :tenants_module_viewer do
     has_permission_on :student_tenants, :to => [:read, :tenant_report, :index_staff, :tenant_report_staff, :reports, :statistics, :laporan_penginapan, :laporan_penginapan2, :census, :census_level]
  end
  role :tenants_module_user do
     has_permission_on :student_tenants, :to => [:read, :update, :tenant_report, :index_staff, :tenant_report_staff, :reports,:room_map,:room_map2, :return_key, :return_key2, :statistics, :laporan_penginapan, :laporan_penginapan2, :census, :census_level]
  end
# NOTE - DISABLE(in EACH radio buttons - locationown[0].disabled=true) as the owner of this module requires 'Facilities Administrator' role + warden requires read only
#   role :tenants_module_member do
#     #own (facailities administrator)
#      has_permission_on :student_tenants, :to => [:manage, :index_staff, :reports,:census_level, :room_map, :room_map2, :statistics, :return_key, :return_key2, :census, :tenant_report, :tenant_report_staff, :laporan_penginapan, :laporan_penginapan2]
#      #own (warden)
#      has_permission_on :student_tenants, :to => :read
#   end

  #18-OK
  #18 - 3/4 OK (Admin, Viewer, User) - 9Feb2016
  role :locations_module_admin do
    has_permission_on :campus_locations, :to => [:manage, :statistic_level, :statistic_block, :census_level2, :kewpa7, :kewpa10, :kewpa11]
  end
  role :locations_module_viewer do
    has_permission_on :campus_locations, :to => [:read, :statistic_level, :statistic_block, :census_level2, :kewpa7, :kewpa10, :kewpa11] 
  end
  role :locations_module_user do
    has_permission_on :campus_locations, :to => [:read, :update, :statistic_level, :statistic_block, :census_level2, :kewpa7, :kewpa10, :kewpa11] 
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - locationown[1].disabled=true) as the owner of this module requires 'Asset Administrator' / 'Facilities Administrator' role & 'Staff' / 'Warden' requires read only
#   role :locations_module_member do
#     #from Staff / Warden role
#     has_permission_on :campus_locations, :to => [:read, :kewpa7]    
#     #from Asset Administrator
#     has_permission_on :campus_locations, :to => [:manage, :kewpa7, :kewpa10, :kewpa11]
#     #from Facilities Administrator
#     has_permission_on :campus_locations, :to => [:manage, :kewpa7, :kewpa10, :kewpa11, :statistic_level, :census_level2, :statistic_block] 
#   end
  
  #19-OK
  #19 - 3/4 OK (Admin, Viewer, User) - 9Feb2016
  role :location_damages_module_admin do
    has_permission_on :campus_location_damages, :to => [:manage, :index_staff, :damage_report, :damage_report_staff]
  end
  role :location_damages_module_viewer do
    has_permission_on :campus_location_damages, :to => [:read, :index_staff, :damage_report, :damage_report_staff]
  end
  role :location_damages_module_user do
    has_permission_on :campus_location_damages, :to => [:read, :update, :index_staff, :damage_report, :damage_report_staff]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - locationown[2].disabled=true as the only owner of this module requires 'Facilities Administrator' role 
#   role :location_damages_module_member do
#     #own records
#     has_permission_on :campus_location_damages, :to =>[:manage, :index_staff, :damage_report, :damage_report_staff]
#   end
  
  #20-OK -  but note read/manage - xls links accessible via INDEX pg, when index accessible(index.xls)
  #kumpulan_etnik_main->kumpulan_etnik(PDF)==kumpulan_etnik_excel(xls)
  role :student_infos_module_admin do
     has_permission_on :students, :to => [:manage, :borang_maklumat_pelajar, :import_excel, :import, :download_excel_format, :reports, :kumpulan_etnik_main, :kumpulan_etnik, :kumpulan_etnik_excel, :students_quantity_sponsor, :students_quantity_report] 
  end
  role :student_infos_module_viewer do
     has_permission_on :students, :to => [:read, :borang_maklumat_pelajar, :reports, :kumpulan_etnik_main, :kumpulan_etnik, :kumpulan_etnik_excel, :students_quantity_sponsor, :students_quantity_report]
  end
  role :student_infos_module_user do
     has_permission_on :students, :to => [:read, :update, :borang_maklumat_pelajar, :reports, :kumpulan_etnik_main, :kumpulan_etnik, :kumpulan_etnik_excel, :students_quantity_sponsor, :students_quantity_report]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - studentown[4].disabled=true as the owner of this module requires 'Student' or 'Student Administration'
# Note too, most roles have at least READ access for this module
#   role :student_infos_module_member do
#     #own record
#      has_permission_on :students, :to => [:update, :show, :borang_maklumat_pelajar] do 
#        if_attribute :id => is {user.userable.id}
#      end
#      #own (Student Administrator)
#      has_permission_on :students, :to => [:manage, :borang_maklumat_pelajar, :import_excel, :import, :download_excel_format, :reports, :kumpulan_etnik_main, :kumpulan_etnik, :kumpulan_etnik_excel, :students_quantity_sponsor, :students_quantity_report] 
#      #own (read only)
#      #Warden, Counselor, Disciplinary Officer, Student, Student Admnistrator, Librarian, Lecturer
#   end
  #####end for Student's related modules################################# 
  #####starts of Training modules####################################
  #Training menus require - training notes (menu) access 
  #21-OK
  #21 - 3/4 OK - 9Feb2016
  role :training_notes_module_admin do
     has_permission_on :training_trainingnotes, :to => [:menu, :manage]
  end
  role :training_notes_module_viewer do
     has_permission_on :training_trainingnotes, :to => [:menu, :read]
  end
  role :training_notes_module_user do
     has_permission_on :training_trainingnotes, :to => [:menu, :read, :update]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - training[0].disabled=true as the only owner of this module requires 'Lecturer' role 
#   role :training_notes_module_member do
#     #own records (lecturer only)
#     has_permission_on :training_trainingnotes, :to => :manage, :join_by => :or do
#       if_attribute :topicdetail_id => is_in {user.topicdetails_of_programme}
#       if_attribute :timetable_id => is_in {user.timetables_of_programme} 
#     end
#     has_permission_on :training_trainingnotes, :to => :manage, :join_by => :and do
#       if_attribute :topicdetail_id => is {nil}
#       if_attribute :timetable_id => is {nil}
#     end
#   end

  #22-OK
  #22 - 3/4 OK - 9Feb2016
  role :academic_session_module_admin do
     has_permission_on :training_academic_sessions, :to => :manage
  end
  role :academic_session_module_viewer do
     has_permission_on :training_academic_sessions, :to => :read
  end
  role :academic_session_module_user do
     has_permission_on :training_academic_sessions, :to =>[:read, :update]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - training[1].disabled=true as the only owner of this module requires 'Programme Manager' role 

  #23-OK 
  role :student_intake_module_admin do
     has_permission_on :training_intakes, :to => :manage
  end
  role :student_intake_module_viewer do
     has_permission_on :training_intakes, :to => :read
  end
  role :student_intake_module_user do
    has_permission_on :training_intakes, :to => [:read, :update]
  end
  role :student_intake_module_member do
    has_permission_on :training_intakes, :to => :read
    # NOTE - restriction on updates - lecturers of the same programme only
    has_permission_on :training_intakes, :to => :update do
      if_attribute :programme_id => is_in {Programme.where(name: Position.where(staff_id: user.userable.id).first.unit).pluck(:id)}
    end
  end

  #24-OK
  role :timetables_module_admin do
     has_permission_on :training_timetables, :to => :manage
  end
  role :timetables_module_viewer do
     has_permission_on :training_timetables, :to => :read
  end
  role :timetables_module_user do
     has_permission_on :training_timetables, :to => [:read, :update]
  end
  role :timetables_module_member do
     has_permission_on :training_timetables, :to => :manage do
       if_attribute :created_by => is {user.userable.id}
     end
  end
  
  #25-OK
  #25 - 3/4 OK (Admin/Viewer/User)
  role :lesson_plans_module_admin do
     has_permission_on :training_lesson_plans, :to => [:manage, :lessonplan_reporting, :lesson_plan, :lesson_report]
  end
  role :lesson_plans_module_viewer do
     has_permission_on :training_lesson_plans, :to => [:read, :lesson_plan, :lesson_report]
  end
  role :lesson_plans_module_user do
     has_permission_on :training_lesson_plans, :to => [:read, :update, :lessonplan_reporting, :lesson_plan, :lesson_report]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - training[0].disabled=true as the only owner of this module requires 'Lecturer' & 'Programme Manager' role 
#   role :lesson_plans_module_member do
#      #own (Programme Manager)
#      has_permission_on :training_lesson_plans, :to => [:read, :lesson_plan, :lesson_report, :delete] do
#       if_attribute :lecturer => is_in {user.unit_members}
#     end
#     has_permission_on :training_lesson_plans, :to =>:update, :join_by => :and do
#       if_attribute :lecturer => is_in {user.unit_members}
#       if_attribute :is_submitted => is {true}
#       if_attribute :hod_approved => is_not {true}
#     end
#     has_permission_on :training_lesson_plans, :to => [:lessonplan_reporting, :update], :join_by  => :and do
#       if_attribute :lecturer => is {user.userable_id}
#       if_attribute :is_submitted => is {true}
#       if_attribute :hod_approved => is {true}
#       if_attribute :report_submit => is {true}
#     end
#     #own (lecturer)
#     has_permission_on :training_lesson_plans, :to => :create
#     has_permission_on :training_lesson_plans, :to => [:read, :lesson_plan, :lesson_report] do
#       if_attribute :lecturer => is {user.userable_id}
#     end
#     has_permission_on :training_lesson_plans, :to => :update, :join_by => :and do
#       if_attribute :lecturer => is {user.userable_id}
#       if_attribute :is_submitted => is_not {true}
#     end
#     has_permission_on :training_lesson_plans, :to => [:lessonplan_reporting, :update], :join_by => :and do
#       if_attribute :lecturer => is {user.userable_id}
#       if_attribute :is_submitted => is {true}
#       if_attribute :hod_approved => is {true}
#       if_attribute :report_submit => is_not {true}
#     end
#   end
  
  #26-OK
  #26 - 3/4 OK (Admin/Viewer/User) - 9Feb2016
  role :topic_details_module_admin do
    has_permission_on :training_topicdetails, :to => :manage
  end
  role :topic_details_module_viewer do
    has_permission_on :training_topicdetails, :to => :read
  end
  role :topic_details_module_user do
    has_permission_on :training_topicdetails, :to => [:read, :update]
  end
  # NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - training[5].disabled=true as the only owner of this module requires 'Programme Manager' role
  
  #27-OK
  #27 - 3/4 OK (Admin/Viewer/User) - 9Feb2016
  role :programmes_module_admin do
    has_permission_on :training_programmes, :to => :manage
  end
  role :programmes_module_viewer do
    has_permission_on :training_programmes, :to => :read
  end
  role :programmes_module_user do
    has_permission_on :training_programmes, :to => [:read, :update]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - training[6].disabled=true as the only owner of this module requires 'Programme Manager' role
  
  #28-OK but requires additional rules as personalize pages is based on logged-in user (existing one requires lecturer's role)
  role :weeklytimetables_module_admin do
     has_permission_on :training_weeklytimetables, :to => [:manage, :weekly_timetable, :approval]
     has_permission_on :training_weeklytimetables, :to => [:personalize_index, :personalize_timetable, :personalize_show, :personalizetimetable] do
       if_attribute :staff_id =>  is {user.userable_id}
     end
  end
  role :weeklytimetables_module_viewer do
     has_permission_on :training_weeklytimetables, :to => [:read, :weekly_timetable]
     has_permission_on :training_weeklytimetables, :to => [:personalize_index, :personalize_timetable, :personalize_show, :personalizetimetable] do
       if_attribute :staff_id =>  is {user.userable_id}
     end
  end
  role :weeklytimetables_module_user do
    has_permission_on :training_weeklytimetables, :to => [:read, :update, :approval, :weekly_timetable]
     has_permission_on :training_weeklytimetables, :to => [:personalize_index, :personalize_timetable, :personalize_show, :personalizetimetable] do
       if_attribute :staff_id =>  is {user.userable_id}
     end
  end
  role :weeklytimetables_module_member do
    #own (lecturer / coordinator) - lecturer role?, Coordinator may use this to manage Weeklytimetable
    #HACK : INDEX (new) - restricted access except for Penyelaras Kumpulan (diploma & posbasics)
    has_permission_on :training_weeklytimetables, :to => [:menu, :read, :create]
   
    #HACK : INDEX (list+show)- restricted access except for Penyelaras Kumpulan/Ketua Program/Ketua Subjek(+'unit_leader' role)/Administration/creator(prepared_by)
    #HACK : SHOW (+edit) - restricted access UNLESS is_submitted!=true (+submission only allowed for Penyelaras Kumpulan)
    has_permission_on :training_weeklytimetables, :to => [:manage, :weekly_timetable] do
      if_attribute :programme_id => is_in {Programme.where(name: Position.where(staff_id: user.userable.id).first.unit).pluck(:id)}
    end

    has_permission_on :training_weeklytimetables, :to => [:personalize_index, :personalize_show, :personalize_timetable, :personalizetimetable] do
      if_attribute :staff_id => is {user.userable_id}
    end
    #programme mgr
    #SHOW (approval button) & approval action
    has_permission_on :training_weeklytimetables, :to => :approval, :join_by => :and do
      if_attribute :is_submitted => is {true}
      if_attribute :programme_id => is_in {Programme.where(name: Position.where(staff_id: user.userable.id).first.unit).pluck(:id)}
    end
  end
  #####end for Training modules####################################
  #####start of Library modules####################################
  #29-OK, extend, return completed
  #29 - 3/4 OK (Admin/Viewer/User)
  role :library_transactions_module_admin do
    has_permission_on :library_librarytransactions, :to => [:manage, :extending, :returning, :check_status, :analysis_statistic, :analysis_statistic_main, :analysis, :analysis_book, :general_analysis, :general_analysis_ext] 
  end
  role :library_transactions_module_viewer do
    has_permission_on :library_librarytransactions, :to => [:read, :analysis_statistic, :analysis_statistic_main, :analysis, :analysis_book, :general_analysis, :general_analysis_ext] 
  end
  role :library_transactions_module_user do
    has_permission_on :library_librarytransactions, :to => [:read, :update, :analysis_statistic, :analysis_statistic_main, :analysis, :analysis_book, :general_analysis, :general_analysis_ext]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - lbrary[0].disabled=true as the only owner of this module requires 'Librarian' role
#   role :library_transactions_module_member do
#   end
  
  #30-OK
  role :library_books_module_admin do
     has_permission_on :library_books, :to => [:manage, :import_excel, :download_excel_format, :import]
  end
  role :library_books_module_viewer do
     has_permission_on :library_books, :to => :read 
  end
  role :library_books_module_user do
    has_permission_on :library_books, :to => [:read, :update]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - lbrary[0].disabled=true as the only owner of this module requires 'Librarian' role
#   role :library_books_module_member do
#   end
  #####end for Library modules####################################
  #start of Examination modules####################################
  #31-OK
  #31 OK - 9Feb2016
  role :exam_templates_module_admin do
     has_permission_on :exam_exam_templates, :to => :manage
  end
  role :exam_templates_module_viewer do
     has_permission_on :exam_exam_templates, :to => :read
  end
  role :exam_templates_module_user do
    has_permission_on :exam_exam_templates, :to => [:read, :update]
  end
  role :exam_templates_module_member do
    has_permission_on :exam_exam_templates, :to => [:read, :update] do
      if_attribute :created_by => is_in {user.unit_members}
    end
  end
  
  #32-OK
  #32-OK - 10Feb2016
  role :examresults_module_admin do
     has_permission_on :exam_examresults, :to => [:manage, :index2, :show2, :show3, :results, :examination_slip, :examination_transcript]
  end
  role :examresults_module_viewer do
     has_permission_on :exam_examresults, :to => [:menu, :read, :index2, :show2, :show3, :results, :examination_slip, :examination_transcript]
  end
  role :examresults_module_user do
    has_permission_on :exam_examresults, :to => [:menu, :read, :update, :index2, :show2, :show3, :results, :examination_slip, :examination_transcript]
  end
  role :examresults_module_member do
    has_permission_on :exam_examresults, :to => [:manage, :index2, :show2, :show3, :results, :examination_slip, :examination_transcript] do
      if_attribute :programme_id => is_in {Programme.where(name: Position.where(staff_id: user.userable.id).first.unit).pluck(:id)}
    end
  end
  
  #33-OK
  #33 OK - 10Feb2016
  role :exam_grade_module_admin do
     has_permission_on :exam_grades, :to =>[:manage, :new_multiple, :edit_multiple, :create_multiple, :update_multiple]
  end
  role :exam_grade_module_viewer do
     has_permission_on :exam_grades, :to =>[:menu, :read]
  end
  role :exam_grade_module_user do
     has_permission_on :exam_grades, :to =>[:menu, :read, :update, :edit_multiple, :update_multiple]
  end
  role :exam_grade_module_member do
    ###own (of same programme)
    has_permission_on :exam_grades, :to => [:menu, :read, :index, :create, :new_multiple, :create_multiple]
    has_permission_on :exam_grades, :to => [:update, :delete, :edit_multiple, :update_multiple] do
      if_attribute :id => is_in {user.grades_of_programme}
    end
  end

  #34-OK
  #34 OK - 10Feb2016
  role :exammarks_module_admin do
     has_permission_on :exam_exammarks, :to => [:manage, :new_multiple, :edit_multiple, :create_multiple, :update_multiple]
  end
  role :exammarks_module_viewer do
     has_permission_on :exam_exammarks, :to => [:menu, :read]
  end
  role :exammarks_module_user do
     has_permission_on :exam_exammarks, :to => [:menu, :read, :update, :edit_multiple, :update_multiple ]
  end
  role :exammarks_module_member do
    ###own (of same programme)
    has_permission_on :exam_exammarks, :to => [:menu, :read, :index, :create, :new_multiple, :create_multiple]
    has_permission_on :exam_exammarks, :to =>[:update, :delete, :edit_multiple, :update_multiple, :new_multiple, :create_multiple] do
      if_attribute :exam_id => is_in {user.exams_of_programme}
    end
  end
  
  #35-OK
  #35 OK - 10Feb2016
  role :exam_analysis_module_admin do
     has_permission_on :exam_examanalyses, :to => [:manage, :analysis_data]
  end
  role :exam_analysis_module_viewer do
     has_permission_on :exam_examanalyses, :to => [:menu, :read, :analysis_data]
  end
  role :exam_analysis_module_user do
     has_permission_on :exam_examanalyses, :to => [:menu, :read, :update, :analysis_data]
  end
  role :exam_analysis_module_member do
    #own (exam admin - creator)
    has_permission_on :exam_examanalyses, :to => [:menu, :read, :create]
    has_permission_on :exam_examanalyses, :to => [:edit, :update, :delete, :analysis_data] do
      if_attribute :exam_id => is_in {user.by_programme_exams}  
    end
    #own (programme mgr)
    has_permission_on :exam_examanalyses, :to => [:menu, :read] do
      if_attribute :exam_id => is_in {user.by_programme_exams}  
    end
  end
  
  #36-OK - 9Feb2016
  role :exampaper_module_admin do
     has_permission_on :exam_exams, :to => [:manage, :exampaper, :question_selection]
  end
  role :exampaper_module_viewer do
     has_permission_on :exam_exams, :to => [:menu, :read, :exampaper]
  end
  role :exampaper_module_user do
    has_permission_on :exam_exams, :to => [:menu, :read, :update, :exampaper]
  end
  role :exampaper_module_member do
    has_permission_on :exam_exams, :to => [:menu, :read, :update, :exampaper] do
      if_attribute :created_by => is_in {user.unit_members}
    end
  end
  
  #37-OK - 3/4 OK (Admin, Viewer, User) - revised on 19Feb2016, disable Member (use 'Lecturer' role instead)
  role :examquestions_module_admin do
     has_permission_on :exam_examquestions, :to => :manage
  end
  role :examquestions_module_viewer do
     has_permission_on :exam_examquestions, :to => [:menu, :read]
  end
  role :examquestions_module_user do
     has_permission_on :exam_examquestions, :to => [:menu, :read, :index, :update]
  end
#   role :examquestions_module_member do
#     has_permission_on :exam_examquestions, :to => [:menu, :read, :index, :create]
#     has_permission_on :exam_examquestions, :to => :update do
#       if_attribute :programme_id => is_in {user.lecturers_programme}
#     end
#   end
  
  #50-added 10Feb2016
  #50 OK but (Admin/Viewer/User-may be assigned to anybody-All records whereas MEMBER - must be assigned to lecturers to get this programme mgr's access)
  role :course_evaluation_module_admin do
    has_permission_on :exam_evaluate_courses, :to => [:manage, :courseevaluation, :evaluation_report]
  end
  role :course_evaluation_module_viewer do
    has_permission_on :exam_evaluate_courses, :to => [:read, :courseevaluation, :evaluation_report]
  end
  role :course_evaluation_module_user do
    has_permission_on :exam_evaluate_courses, :to => [:read, :courseevaluation, :evaluation_report, :update]
  end
  role :course_evaluation_module_member do
    #own record (student)
    has_permission_on :exam_evaluate_courses, :to => [:index, :create] do
      has_permission_on :exam_evaluate_courses, :to => [:read, :update, :courseevaluation] do
        if_attribute :student_id => is {user.userable.id}
      end
    end
    #own (programme manager-reader)
    has_permission_on :exam_evaluate_courses, :to => [:read, :courseevaluation, :evaluation_report] do
      if_attribute :course_id => is_in {user.evaluations_of_programme}
    end
  end
  #end for Examination modules####################################
  #start of Assets modules#######################################
  #38-OK
  role :stationeries_module_admin do
     has_permission_on :asset_stationeries, :to => [:manage, :kewps13]
  end
  role :stationeries_module_viewer do
     has_permission_on :asset_stationeries, :to => [:read, :kewps13]
  end
  role :stationeries_module_user do
     has_permission_on :asset_stationeries, :to => [:read, :update, :kewps13]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - assetown[0].disabled=true as there's no specific role & above 3 access are adequate
#   role :stationeries_module_member do
#      has_permission_on :asset_stationeries, :to => [:read, :update, :kewps13]
#   end
 
  #39-OK - but kewpa31 link not ready (write-off)
  role :asset_losses_module_admin do
     has_permission_on :asset_asset_losses, :to => [:manage, :kewpa28, :kewpa29, :kewpa30, :kewpa31]
  end
  role :asset_losses_module_viewer do
     has_permission_on :asset_asset_losses, :to => [:read, :kewpa28, :kewpa29, :kewpa30, :kewpa31] 
  end
  role :asset_losses_module_user do
    has_permission_on :asset_asset_losses, :to => [:read, :update, :kewpa28, :kewpa29, :kewpa30, :kewpa31] 
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - assetown[1].disabled=true as the only owner is asset_administrator

  #40-OK
  #40 - OK 10Feb2016
  role :asset_loans_module_admin do
     has_permission_on :asset_asset_loans, :to => [:manage, :approval, :lampiran_a]
  end
  role :asset_loans_module_viewer do
     has_permission_on :asset_asset_loans, :to => [:read, :lampiran_a]
  end
  role :asset_loans_module_user do
    has_permission_on :asset_asset_loans, :to => [:read, :approval, :update, :lampiran_a]
  end
  role :asset_loans_module_member do
    #own record (staff - loaner / unit members)
    has_permission_on :asset_asset_loans, :to => :create                                                          # A staff can create loan
    has_permission_on :asset_asset_loans, :to =>:read do 
      if_attribute :staff_id => is {user.userable.id}
    end
    has_permission_on :asset_asset_loans, :to =>:update, :join_by => :and do                         # applicant can update unless loan is approved
      if_attribute :staff_id => is {user.userable.id}
      if_attribute :is_approved => is_not {true}
    end
    has_permission_on :asset_asset_loans, :to => [:read, :lampiran_a] do                                 # loan can be viewed by Unit Members
      if_attribute :loaned_by => is_in {user.unit_members}
    end
    has_permission_on :asset_asset_loans, :to => [:update, :approval], :join_by => :and do     # loan can be approved by Unit Members when not yet approved 
      if_attribute :loaned_by => is_in {user.unit_members}
      if_attribute :is_approved => is_not {true}
    end
    has_permission_on :asset_asset_loans, :to => :update, :join_by => :and do                         # As of Travel Request,Claim, AssetDefect - loaner must not hv access to EDIT 
      if_attribute :loaned_by => is_in {user.unit_members}                                                           # temp - hide in Edit as of Travel Claim & AssetDefect
      if_attribute :is_approved => is {true}
      if_attribute :is_returned => is_not {true}
    end
    #own (approval - asset admin)
    has_permission_on :asset_asset_loans, :to => [:read, :lampiran_a]
    has_permission_on :asset_asset_loans, :to => [:update, :approval] , :join_by => :and do
      if_attribute :is_returned => is_not {true}
    end
  end
  
  #41-OK
  role :asset_disposals_module_admin do
     has_permission_on :asset_asset_disposals, :to =>[:manage, :kewpa17_20, :kewpa17, :kewpa20, :kewpa16, :kewpa18, :kewpa19, :dispose, :revalue, :verify, :view_close]
  end
  role :asset_disposals_module_viewer do
     has_permission_on :asset_asset_disposals, :to => [:read, :kewpa17_20, :kewpa17, :kewpa20, :kewpa16, :kewpa18, :kewpa19]
  end
  role :asset_disposals_module_user do
     has_permission_on :asset_asset_disposals, :to =>[:read, :update, :kewpa17_20, :kewpa17, :kewpa20, :kewpa16, :kewpa18, :kewpa19, :dispose, :revalue, :verify, :view_close]
  end
# NOTE - DISABLE(in EACH radio buttons/click : radio & checkbox - assetown[1].disabled=true as the only owner is asset_administrator

  #42-OK
  #42 3/4 OK (Admin/Viewer/User) - Member : workable for reporter & decisioner only
  role :asset_defect_module_admin do
    has_permission_on :asset_asset_defects, :to => [:manage, :process2, :decision, :kewpa9]
  end
  role :asset_defect_module_viewer do
    has_permission_on :asset_asset_defects, :to => [:read, :kewpa9]
  end
  role :asset_defect_module_user do
    has_permission_on :asset_asset_defects, :to => [:read, :update, :process2, :decision, :kewpa9]
  end
  # NOTE - workable only for defect reporter & decisioner, still require 'Asset Administrator' role for 1st time access of defectives one, for processing purpose.
  role :asset_defect_module_member do
    #own records (Staff role)
    has_permission_on :asset_asset_defects, :to => :create                                                        # A staff can register & update defect
    has_permission_on :asset_asset_defects, :to => :read do
      if_attribute :reported_by => is {user.userable.id}
    end
    has_permission_on :asset_asset_defects, :to => :update, :join_by => :and do                     # Applicant may update unless defect processed
      if_attribute :reported_by => is {user.userable.id}
      if_attribute :is_processed => is_not {true}
    end
    #own (processor or decisioner)
    has_permission_on :asset_asset_defects, :to => [:read, :kewpa9], :join_by => :and do        # Processor & decision maker may show / pdf
      if_attribute :processed_by => is {user.userable.id}
      if_attribute :decision_by => is {user.userable.id}
    end
    #own (processor)
    has_permission_on :asset_asset_defects, :to => [:update, :process2, :kewpa9], :join_by => :and do  # previous Asset Admin - pending - may process unless defect processed
      if_attribute :processed_by => is {user.userable.id}
      if_attribute :is_processed => is_not {true}
    end
    #own (decisioner)
    has_permission_on :asset_asset_defects, :to => [:update, :decision, :kewpa9], :join_by => :and do   # Decision maker may decide unless decision has been made
      if_attribute :decision_by => is {user.userable.id}
      if_attribute :decision => is_not {true}
    end
    #own (processor - use of 'Asset Administrator' role)
    has_permission_on :asset_asset_defects, :to =>[:read, :kewpa9]
    has_permission_on :asset_asset_defects, :to =>[:update, :process2], :join_by => :and do #3nov2013, 21Jan2016
      if_attribute :is_processed => is_not {true}
    end
  end
  
  #43-OK, but for read - price is hidden & visible only to those with update access
  #43 3/4 OK (Admin/User/Member), Viewer - restricted access for document containing pricing details : cost/maintenance
  role :asset_list_module_admin do
    has_permission_on :asset_assets, :to => [:manage, :kewpa2, :kewpa3, :kewpa4, :kewpa5, :kewpa6, :kewpa8, :kewpa13, :kewpa14, :loanables]
  end
  #restriction - no PDF allowed : contains pricing details 2, 3, 4, 5 & 8 (kos perolehan) 13 & 14 (maintenance) 
  role :asset_list_module_viewer do
    has_permission_on :asset_assets, :to => [:read, :kewpa6, :loanables] 
  end
  role :asset_list_module_user do
    has_permission_on :asset_assets, :to => [:read, :update, :kewpa2, :kewpa3, :kewpa4, :kewpa5, :kewpa6, :kewpa8, :kewpa13, :kewpa14, :loanables]
  end
  role :asset_list_module_member do
    has_permission_on :asset_assets, :to => [:read, :loanables]
  end
  #end for Assets modules#######################################
  #start of Support table / E FIlling modules##################################
  #44-OK
  role :events_module_admin do
     has_permission_on :events, :to => :manage
  end
  role :events_module_viewer do
     has_permission_on :events, :to => :read
  end
  role :events_module_user do
     has_permission_on :events, :to => [:read, :update]
  end
  role :events_module_member do
    has_permission_on :events, :to => [:create, :read]                                                             # A staff can read, create but update own
    has_permission_on :events, :to => :update do
      if_attribute :createdby => is {user.userable.id}
    end
  end
  
  #45-OK
  role :bulletins_module_admin do
     has_permission_on :bulletins, :to =>:manage
  end
  role :bulletins_module_viewer do
     has_permission_on :bulletins, :to => :read
  end
  role :bulletins_module_user do
    has_permission_on :bulletins, :to => [:read, :update]
  end
  role :bulletins_module_member do
    has_permission_on :bulletins, :to => [:create, :read]                                                             # A staff can read, create but update own
    has_permission_on :bulletins, :to => :update do
      if_attribute :postedby_id => is {user.userable.id}
    end
  end

  #46-OK
  role :files_module_admin do
     has_permission_on :cofiles, :to => :manage
  end
  role :files_module_viewer do
     has_permission_on :cofiles, :to => :read
  end
  role :files_module_user do
    has_permission_on :cofiles, :to => [:read, :update]
  end
  role :files_module_member do
    has_permission_on :cofiles, :to => [:read, :create]
    has_permission_on :cofiles, :to => :update do
      if_attribute :owner_id => is {user.userable.id}
    end
  end

  #47-OK, but create 
  role :documents_module_admin do
    has_permission_on :documents, :to => [:manage, :document_report]
  end
  role :documents_module_viewer do
    has_permission_on :documents, :to => [:menu, :read, :document_report]
  end
  role :documents_module_user do
    has_permission_on :documents, :to => [:menu, :read, :update, :document_report]
  end
  role :documents_module_member do
    has_permission_on :documents, :to => [:menu, :read, :create]
    has_permission_on :documents, :to => [:update]   do 
      if_attribute :stafffiled_id => is {user.userable.id}
    end
  end
  
  
  
  
  
  
  #OK until here 10Feb2016==============
  #for all modules to work, must activate Staff role OR Staff (Admin/Viewer/User/Member)
  
  
  
  
  
  #48-OK
  role :banks_module_admin do
     has_permission_on :banks, :to => :manage
  end
  role :banks_module_viewer do
     has_permission_on :banks, :to => :read
  end
  
  #49-OK
  role :address_book_module_admin do
     has_permission_on :campus_address_books, :to => :manage
  end
  role :address_book_module_viewer do
     has_permission_on :campus_address_books, :to => :read
  end
  
  # TODO 50-54 when pages ready in Ogma
#   titles
#   staff_shifts
#   travel_claims_transport_groups
#   travel_claim_mileage_rates
#   asset_categories
  
  
#   role :titles
#   role :staff_shift
#   role :travel_claims_transport_group
#   role :travel_claim_mileage_rates
#   role :assetcategories  
  #end for Support table / E- Filling modules##################################
  
  role :users_module do
    has_permission_on :users, :to => :manage
  end
  
  role :roles_module do
    has_permission_on :roles, :to => :manage
  end

#pages
#   role : staff_leave_mailer_module do
#      has_permission_on :leaveforstaffs_mailer, :to => :manage
#   end

#   role :library_mailer_module do
#      has_permission_on :library_mailer, :to => :manage
#   end
 
  #55 - Ogma Only - Recipient GROUP for Local Messaging
  role :messaging_groups_module_admin do
    has_permission_on :groups, :to => :manage
  end
  role :messaging_groups_module_viewer do
    has_permission_on :groups, :to => :read
  end
  #56 - Ogma Only - Local Messaging - FULL access for Conversation but MEMBER access for Group - as in 'Staff' role
  role :local_messaging_module_member do
    has_permission_on :conversations, :to => [:create, :show, :edit_draft, :send_draft, :reply, :trash, :untrash]
    has_permission_on :groups, :to => :menu
    has_permission_on :groups, :to => :show do
      if_attribute :id => is_in {user.members_of_msg_group}
    end
  end
  
  # TODO - instructor_appraisals - other than positions.name=='Jurulatih'
  # TODO average_instructor - supposed those - Bhg Kawalan Mutu / kompetensi, temp - programme mgr
  
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
