Ogma::Application.routes.draw do

  namespace :staff do
    resources :staffs, as: :infos do
      member do
        get :borang_maklumat_staff
      end
      collection do
        get :autocomplete
      end
    end
    resources :positions do
      collection do
        get :maklumat_perjawatan
        get :maklumat_perjawatan_excel
        get :organisation_chart
      end
    end
    resources :staff_appraisals do
      member do
        get :appraisal_form
      end
    end
    resources :leaveforstaffs do
      member do
        get :processing_level_1
        get :processing_level_2
      end
    end
    resources :travel_claims do
      member do
        get :check
        get :approve
        get :claimprint
      end
    end
    resources :staff_attendances do
      collection do
        put 'actionable', to: "staff_attendances#actionable"
        post 'import'
        get 'import_excel', to: "staff_attendances#import_excel"
        get :attendance_report
	post :attendance_report
	get :attendance_report_main
	get :daily_report
	get :weekly_report
	get :monthly_report
	get :monthly_listing
        get :monthly_details
        get :manager_admin
      end
    end
    resources :fingerprints do
      collection do
        get :approval
        get :index_admin
      end
    end
    resources :holidays
    resources :attendances
    resources :travel_requests do
      member do
        get :travel_log
        get :approval
        get 'status_movement'
      end
      collection do
        get :travel_log_index
      end
    end
    resources :vehicles
    resources :ranks
  end

  match '/travel_requests/logs', to: 'staff/travel_requests#travel_log_index', via: 'get'
  match '/attendance/manager', to: 'staff/staff_attendances#manager', via: 'get'
  match '/attendance/status/', to: 'staff/staff_attendances#status', via: 'get'
  match '/attendance/approval/', to: 'staff/staff_attendances#approval', via: 'get'
  match '/attendance/report', to: 'staff/staff_attendances#report', via: 'get'
  match '/public/excel_format/staff_attendance_import.xls', to: 'staff/staff_attendances#download_excel_format', via: 'get', target: '_self'

  namespace :staff_training do
    resources :ptbudgets
    resources :ptcourses
    resources :ptschedules do
      collection do
        get :participants_expenses
      end
    end
    resources :ptdos do
      collection do
        get :show_total_days
        get :training_report
      end
    end
  end


  namespace :asset do
    resources :assets do
      member do
        get :kewpa3
        get :kewpa2
        get :kewpa14
        get :kewpa6
      end
      collection do
        get   :fixed_assets
        post  :fixed_assets
        get   :inventory
        post  :inventory
        get :loanables
        get :kewpa4
        get :kewpa5
        get :kewpa8
        get :kewpa13
      end
    end
    resources :stationeries do
      collection do
        get :kewps13
      end
    end
    resources :asset_defects,   as: :defects do
      member do
        get :kewpa9
        get :process2
        get :decision
      end
    end
    resources :asset_losses,    as: :losses do
    member do
      get :kewpa28
      get :kewpa29
      get :kewpa30
    end
    collection do
      get :kewpa31
    end
  end
    resources :asset_disposals, as: :disposals do
      member do
        get :kewpa16
        get :kewpa18
        get :kewpa19
        get :revalue
        get :dispose
        get :verify
        get :view_close
      end
      collection do
        get :kewpa17
        get :kewpa20
        get :kewpa17_20
      end
    end
    resources :asset_loans, as: :loans do
      member do
        get :approval
        get :lampiran_a
      end
    end
  end

  namespace :campus do
    resources :locations do
      member do
        get :kewpa7
        get :kewpa10
        get :kewpa11
      end
      collection do
        get :statistic_level
        get :census_level2
        get :statistic_block
      end
    end
    resources :location_damages do
      collection do
        get :damage_report
        get :damage_report_staff
        get :index_staff
      end
    end
    resources :address_books
  end

  resources :events do
    member do
      get :calendar
    end
  end

  resources :cofiles

  resources :documents do
    collection do
      get :document_report
    end
  end

  resources :students do
    collection do
      get :autocomplete
      get :kumpulan_etnik
      post :kumpulan_etnik
      get :reports
      get :students_quantity_sponsor
      get :students_quantity_report
      get :student_report
      get :kumpulan_etnik_main
      get :kumpulan_etnik_excel
      post :import
      get 'import_excel', to: "students#import_excel"
    end
    member do
      get :borang_maklumat_pelajar
    end
  end

  match '/public/excel_format/student_import.xls', to: 'students#download_excel_format', via: 'get', target: '_self'

  namespace :student do
    resources :tenants do
      collection do
        get :index_staff
        get :room_map
        get :room_map2
        get :reports
        get :statistics
        get :census
        get  :return_key
        post :return_key
	get  :return_key2
        post :return_key2
        get  :empty_room
        post :empty_room
        get :tenant_report
        get :tenant_report_staff
        get :laporan_penginapan
        get :laporan_penginapan2
      end
      member do
        get :census_level
	get :return_key
        get :return_key2
      end
    end
    resources :student_discipline_cases do
      member do
        get :actiontaken
        get :referbpl
      end
      collection do
        get :reports
        get :anacdotal_report
        post :anacdotal_report
        get :discipline_report
      end
    end
    resources :student_counseling_sessions do
      member do
        get :feedback
      end
      collection do
        get :feedback_referrer
      end
    end
    resources :leaveforstudents do
      member do
        get :approve_coordinator
        get :approve_warden
        get :approving
        get :slip_pengesahan_cuti_pelajar
      end
      collection do
        get :studentleave_report
      end
    end
    resources :student_attendances do
      collection do
        put 'edit_multiple', to:"student_attendances#edit_multiple"
        get :student_attendan_form
        get :examination_slip
        put 'edit_multiple'
        post 'update_multiple'
        put 'new_multiple'
        put 'new_multiple_intake'
        post 'create_multiple'
      end
    end
  end

  resources :bulletins

  namespace :training do
    resources :programmes
    resources :intakes
    resources :timetables
    resources :timetable_periods
    resources :academic_sessions
    resources :topicdetails
    resources :trainingnotes
    resources :lesson_plans do
      member do
        get :lesson_report
        get :lesson_plan
        get :lessonplan_reporting
        get :add_notes
      end
      collection do
        get :index_report
      end
    end
    resources :weeklytimetables do
      member do
        get :personalize_show
        get :weekly_timetable
        get :personalizetimetable
        get :approval
      end
      collection do
        get 'general_timetable', to: "weeklytimetables#general_timetable"
        get 'personalize_timetable', to: "weeklytimetables#personalize_timetable"
        #get 'personalize_index', to: "weeklytimetables#personalize_index"
        get :personalize_index
      end
    end
  end

  namespace :library do
    resources :librarytransactions do
      member do
        get :extending
        get :returning
      end
      collection do
        get :check_status
        post :check_status
        get   :manager
        post  :manager
        get :iis
	get :analysis
        get :analysis_book
        get :general_analysis
        get :general_analysis_ext
        get :analysis_statistic
        post :analysis_statistic
        get :analysis_statistic_main
      end
    end
    resources :books do
      collection do
	post 'import'
	get 'import_excel', to: "books#import_excel"
        get 'check_availability'
        post 'check_availability'
      end
    end
  end

  match '/public/excel_format/book_import.xls', to: 'library/books#download_excel_format', via: 'get', target: '_self'

  namespace :exam do
    resources :examquestions
    resources :examsubquestions
    resources :answerchoices
    resources :examanswers
    resources :shortessays
    resources :booleanchoices
    resources :booleananswers
    resources :exam_templates
    resources :exams do
      #map.connect '/exams/exampaper', :controller => 'exams', :action => 'exampaper'
      #map.connect '/exams/exampaper_separate', :controller => 'exams', :action => 'exampaper_separate'
      #map.connect '/exams/exampaper_combine', :controller => 'exams', :action => 'exampaper_combine'
      member do
        get :exampaper
	#get :question_selection
      end
#       collection do
#         get 'exampaper', to: "exams#exampaper"
#         get 'exampaper_separate', to: "exams#exampaper_separate"
#         get 'exampaper_combine', to: "exams#exampaper_combine"
#       end
    end

    resources :exammarks do
      collection do
        put 'edit_multiple'
        post 'update_multiple'
        put 'new_multiple'
        post 'create_multiple'
      end
    end
    resources :grades do
      collection do
        put 'edit_multiple'
        post 'update_multiple', to: "grades#update_multiple"
        put 'new_multiple'
        post 'create_multiple'
	post 'add_formative'
      end
      member do
        get 'add_formative'
      end
    end
    resources :examresults do
      collection do
        get :index2
        post :index2
        get :show2
        get :show3
        get :examination_slip
        get :examination_transcript
        get :results
      end
    end
    resources :examanalyses do
      collection do
        get :analysis_data
      end
    end
    resources :evaluate_courses do
      member do
        get 'courseevaluation'
        #get :evaluation_analysis
      end
      collection do
        get :evaluation_report
      end
    end
    resources :average_courses do
      member do
        get :evaluation_analysis
      end
    end
  end

  devise_for :users
  resources :users do
   member do
    get  :link
    post :link
    put :complete
   end
  end
  resources :logins
  resources :roles
  resources :banks
  
  
  # mailbox folder routes
  get "mailbox/inbox" => "mailbox#inbox", as: :mailbox_inbox
  get "mailbox/sent" => "mailbox#sent", as: :mailbox_sent
  get "mailbox/trash" => "mailbox#trash", as: :mailbox_trash
  
  resources :conversations do
    member do
      post :reply
      post :trash
      post :untrash
      get :edit_draft
      post :send_draft
      #get :upload
    end
    #collection do
    #  get :upload
    #  post :upload
    #end
  end

  resources :groups
  resources :colleges

  root  'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/dashboard', to: 'static_pages#dashboard', via: 'get'
  match '/asset_report', to: 'static_pages#asset_report', via: 'get'
  match '/fetch_items', to: 'exam/exams#question_selection', via: 'get'
  match '/rules_regulations', to: 'static_pages#rules_regulations', via: 'get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

# == Route Map (Updated 2014-06-07 17:19)
#
#                                   Prefix Verb   URI Pattern                                         Controller#Action
#        borang_maklumat_staff_staff_infos GET    /staff/staffs/borang_maklumat_staff(.:format)       staff/staffs#borang_maklumat_staff
#                              staff_infos GET    /staff/staffs(.:format)                             staff/staffs#index
#                                          POST   /staff/staffs(.:format)                             staff/staffs#create
#                           new_staff_info GET    /staff/staffs/new(.:format)                         staff/staffs#new
#                          edit_staff_info GET    /staff/staffs/:id/edit(.:format)                    staff/staffs#edit
#                               staff_info GET    /staff/staffs/:id(.:format)                         staff/staffs#show
#                                          PATCH  /staff/staffs/:id(.:format)                         staff/staffs#update
#                                          PUT    /staff/staffs/:id(.:format)                         staff/staffs#update
#                                          DELETE /staff/staffs/:id(.:format)                         staff/staffs#destroy
#                          staff_positions GET    /staff/positions(.:format)                          staff/positions#index
#                                          POST   /staff/positions(.:format)                          staff/positions#create
#                       new_staff_position GET    /staff/positions/new(.:format)                      staff/positions#new
#                      edit_staff_position GET    /staff/positions/:id/edit(.:format)                 staff/positions#edit
#                           staff_position GET    /staff/positions/:id(.:format)                      staff/positions#show
#                                          PATCH  /staff/positions/:id(.:format)                      staff/positions#update
#                                          PUT    /staff/positions/:id(.:format)                      staff/positions#update
#                                          DELETE /staff/positions/:id(.:format)                      staff/positions#destroy
#                                ptbudgets GET    /ptbudgets(.:format)                                ptbudgets#index
#                                          POST   /ptbudgets(.:format)                                ptbudgets#create
#                             new_ptbudget GET    /ptbudgets/new(.:format)                            ptbudgets#new
#                            edit_ptbudget GET    /ptbudgets/:id/edit(.:format)                       ptbudgets#edit
#                                 ptbudget GET    /ptbudgets/:id(.:format)                            ptbudgets#show
#                                          PATCH  /ptbudgets/:id(.:format)                            ptbudgets#update
#                                          PUT    /ptbudgets/:id(.:format)                            ptbudgets#update
#                                          DELETE /ptbudgets/:id(.:format)                            ptbudgets#destroy
#                       kewpa3_asset_asset GET    /asset/assets/:id/kewpa3(.:format)                  asset/assets#kewpa3
#                       kewpa2_asset_asset GET    /asset/assets/:id/kewpa2(.:format)                  asset/assets#kewpa2
#                      kewpa14_asset_asset GET    /asset/assets/:id/kewpa14(.:format)                 asset/assets#kewpa14
#                       kewpa6_asset_asset GET    /asset/assets/:id/kewpa6(.:format)                  asset/assets#kewpa6
#                fixed_assets_asset_assets GET    /asset/assets/fixed_assets(.:format)                asset/assets#fixed_assets
#                                          POST   /asset/assets/fixed_assets(.:format)                asset/assets#fixed_assets
#                   inventory_asset_assets GET    /asset/assets/inventory(.:format)                   asset/assets#inventory
#                                          POST   /asset/assets/inventory(.:format)                   asset/assets#inventory
#                      kewpa4_asset_assets GET    /asset/assets/kewpa4(.:format)                      asset/assets#kewpa4
#                      kewpa5_asset_assets GET    /asset/assets/kewpa5(.:format)                      asset/assets#kewpa5
#                     kewpa13_asset_assets GET    /asset/assets/kewpa13(.:format)                     asset/assets#kewpa13
#                             asset_assets GET    /asset/assets(.:format)                             asset/assets#index
#                                          POST   /asset/assets(.:format)                             asset/assets#create
#                          new_asset_asset GET    /asset/assets/new(.:format)                         asset/assets#new
#                         edit_asset_asset GET    /asset/assets/:id/edit(.:format)                    asset/assets#edit
#                              asset_asset GET    /asset/assets/:id(.:format)                         asset/assets#show
#                                          PATCH  /asset/assets/:id(.:format)                         asset/assets#update
#                                          PUT    /asset/assets/:id(.:format)                         asset/assets#update
#                                          DELETE /asset/assets/:id(.:format)                         asset/assets#destroy
#                       asset_stationeries GET    /asset/stationeries(.:format)                       asset/stationeries#index
#                                          POST   /asset/stationeries(.:format)                       asset/stationeries#create
#                     new_asset_stationery GET    /asset/stationeries/new(.:format)                   asset/stationeries#new
#                    edit_asset_stationery GET    /asset/stationeries/:id/edit(.:format)              asset/stationeries#edit
#                         asset_stationery GET    /asset/stationeries/:id(.:format)                   asset/stationeries#show
#                                          PATCH  /asset/stationeries/:id(.:format)                   asset/stationeries#update
#                                          PUT    /asset/stationeries/:id(.:format)                   asset/stationeries#update
#                                          DELETE /asset/stationeries/:id(.:format)                   asset/stationeries#destroy
#                      kewpa9_asset_defect GET    /asset/asset_defects/:id/kewpa9(.:format)           asset/asset_defects#kewpa9
#                            asset_defects GET    /asset/asset_defects(.:format)                      asset/asset_defects#index
#                                          POST   /asset/asset_defects(.:format)                      asset/asset_defects#create
#                         new_asset_defect GET    /asset/asset_defects/new(.:format)                  asset/asset_defects#new
#                        edit_asset_defect GET    /asset/asset_defects/:id/edit(.:format)             asset/asset_defects#edit
#                             asset_defect GET    /asset/asset_defects/:id(.:format)                  asset/asset_defects#show
#                                          PATCH  /asset/asset_defects/:id(.:format)                  asset/asset_defects#update
#                                          PUT    /asset/asset_defects/:id(.:format)                  asset/asset_defects#update
#                                          DELETE /asset/asset_defects/:id(.:format)                  asset/asset_defects#destroy
#                             asset_losses GET    /asset/asset_losses(.:format)                       asset/asset_losses#index
#                                          POST   /asset/asset_losses(.:format)                       asset/asset_losses#create
#                           new_asset_loss GET    /asset/asset_losses/new(.:format)                   asset/asset_losses#new
#                          edit_asset_loss GET    /asset/asset_losses/:id/edit(.:format)              asset/asset_losses#edit
#                               asset_loss GET    /asset/asset_losses/:id(.:format)                   asset/asset_losses#show
#                                          PATCH  /asset/asset_losses/:id(.:format)                   asset/asset_losses#update
#                                          PUT    /asset/asset_losses/:id(.:format)                   asset/asset_losses#update
#                                          DELETE /asset/asset_losses/:id(.:format)                   asset/asset_losses#destroy
#                  kewpa17_asset_disposals GET    /asset/asset_disposals/kewpa17(.:format)            asset/asset_disposals#kewpa17
#                  kewpa20_asset_disposals GET    /asset/asset_disposals/kewpa20(.:format)            asset/asset_disposals#kewpa20
#                   kewpa18_asset_disposal GET    /asset/asset_disposals/:id/kewpa18(.:format)        asset/asset_disposals#kewpa18
#                   kewpa19_asset_disposal GET    /asset/asset_disposals/:id/kewpa19(.:format)        asset/asset_disposals#kewpa19
#                          asset_disposals GET    /asset/asset_disposals(.:format)                    asset/asset_disposals#index
#                                          POST   /asset/asset_disposals(.:format)                    asset/asset_disposals#create
#                       new_asset_disposal GET    /asset/asset_disposals/new(.:format)                asset/asset_disposals#new
#                      edit_asset_disposal GET    /asset/asset_disposals/:id/edit(.:format)           asset/asset_disposals#edit
#                           asset_disposal GET    /asset/asset_disposals/:id(.:format)                asset/asset_disposals#show
#                                          PATCH  /asset/asset_disposals/:id(.:format)                asset/asset_disposals#update
#                                          PUT    /asset/asset_disposals/:id(.:format)                asset/asset_disposals#update
#                                          DELETE /asset/asset_disposals/:id(.:format)                asset/asset_disposals#destroy
#                   kewpa7_campus_location GET    /campus/locations/:id/kewpa7(.:format)              campus/locations#kewpa7
#                         campus_locations GET    /campus/locations(.:format)                         campus/locations#index
#                                          POST   /campus/locations(.:format)                         campus/locations#create
#                      new_campus_location GET    /campus/locations/new(.:format)                     campus/locations#new
#                     edit_campus_location GET    /campus/locations/:id/edit(.:format)                campus/locations#edit
#                          campus_location GET    /campus/locations/:id(.:format)                     campus/locations#show
#                                          PATCH  /campus/locations/:id(.:format)                     campus/locations#update
#                                          PUT    /campus/locations/:id(.:format)                     campus/locations#update
#                                          DELETE /campus/locations/:id(.:format)                     campus/locations#destroy
#                  campus_location_damages GET    /campus/location_damages(.:format)                  campus/location_damages#index
#                                          POST   /campus/location_damages(.:format)                  campus/location_damages#create
#               new_campus_location_damage GET    /campus/location_damages/new(.:format)              campus/location_damages#new
#              edit_campus_location_damage GET    /campus/location_damages/:id/edit(.:format)         campus/location_damages#edit
#                   campus_location_damage GET    /campus/location_damages/:id(.:format)              campus/location_damages#show
#                                          PATCH  /campus/location_damages/:id(.:format)              campus/location_damages#update
#                                          PUT    /campus/location_damages/:id(.:format)              campus/location_damages#update
#                                          DELETE /campus/location_damages/:id(.:format)              campus/location_damages#destroy
#                           calendar_event GET    /events/:id/calendar(.:format)                      events#calendar
#                                   events GET    /events(.:format)                                   events#index
#                                          POST   /events(.:format)                                   events#create
#                                new_event GET    /events/new(.:format)                               events#new
#                               edit_event GET    /events/:id/edit(.:format)                          events#edit
#                                    event GET    /events/:id(.:format)                               events#show
#                                          PATCH  /events/:id(.:format)                               events#update
#                                          PUT    /events/:id(.:format)                               events#update
#                                          DELETE /events/:id(.:format)                               events#destroy
#                                  cofiles GET    /cofiles(.:format)                                  cofiles#index
#                                          POST   /cofiles(.:format)                                  cofiles#create
#                               new_cofile GET    /cofiles/new(.:format)                              cofiles#new
#                              edit_cofile GET    /cofiles/:id/edit(.:format)                         cofiles#edit
#                                   cofile GET    /cofiles/:id(.:format)                              cofiles#show
#                                          PATCH  /cofiles/:id(.:format)                              cofiles#update
#                                          PUT    /cofiles/:id(.:format)                              cofiles#update
#                                          DELETE /cofiles/:id(.:format)                              cofiles#destroy
#                                documents GET    /documents(.:format)                                documents#index
#                                          POST   /documents(.:format)                                documents#create
#                             new_document GET    /documents/new(.:format)                            documents#new
#                            edit_document GET    /documents/:id/edit(.:format)                       documents#edit
#                                 document GET    /documents/:id(.:format)                            documents#show
#                                          PATCH  /documents/:id(.:format)                            documents#update
#                                          PUT    /documents/:id(.:format)                            documents#update
#                                          DELETE /documents/:id(.:format)                            documents#destroy
#                    autocomplete_students GET    /students/autocomplete(.:format)                    students#autocomplete
#                                 students GET    /students(.:format)                                 students#index
#                                          POST   /students(.:format)                                 students#create
#                              new_student GET    /students/new(.:format)                             students#new
#                             edit_student GET    /students/:id/edit(.:format)                        students#edit
#                                  student GET    /students/:id(.:format)                             students#show
#                                          PATCH  /students/:id(.:format)                             students#update
#                                          PUT    /students/:id(.:format)                             students#update
#                                          DELETE /students/:id(.:format)                             students#destroy
#                 room_map_student_tenants GET    /student/tenants/room_map(.:format)                 student/tenants#room_map
#               statistics_student_tenants GET    /student/tenants/statistics(.:format)               student/tenants#statistics
#                   census_student_tenants GET    /student/tenants/census(.:format)                   student/tenants#census
#               return_key_student_tenants GET    /student/tenants/return_key(.:format)               student/tenants#return_key
#                                          POST   /student/tenants/return_key(.:format)               student/tenants#return_key
#               empty_room_student_tenants GET    /student/tenants/empty_room(.:format)               student/tenants#empty_room
#                                          POST   /student/tenants/empty_room(.:format)               student/tenants#empty_room
#                          student_tenants GET    /student/tenants(.:format)                          student/tenants#index
#                                          POST   /student/tenants(.:format)                          student/tenants#create
#                       new_student_tenant GET    /student/tenants/new(.:format)                      student/tenants#new
#                      edit_student_tenant GET    /student/tenants/:id/edit(.:format)                 student/tenants#edit
#                           student_tenant GET    /student/tenants/:id(.:format)                      student/tenants#show
#                                          PATCH  /student/tenants/:id(.:format)                      student/tenants#update
#                                          PUT    /student/tenants/:id(.:format)                      student/tenants#update
#                                          DELETE /student/tenants/:id(.:format)                      student/tenants#destroy
#                                bulletins GET    /bulletins(.:format)                                bulletins#index
#                                          POST   /bulletins(.:format)                                bulletins#create
#                             new_bulletin GET    /bulletins/new(.:format)                            bulletins#new
#                            edit_bulletin GET    /bulletins/:id/edit(.:format)                       bulletins#edit
#                                 bulletin GET    /bulletins/:id(.:format)                            bulletins#show
#                                          PATCH  /bulletins/:id(.:format)                            bulletins#update
#                                          PUT    /bulletins/:id(.:format)                            bulletins#update
#                                          DELETE /bulletins/:id(.:format)                            bulletins#destroy
#        extend_library_librarytransaction GET    /library/librarytransactions/:id/extend(.:format)   library/librarytransactions#extend
#        return_library_librarytransaction GET    /library/librarytransactions/:id/return(.:format)   library/librarytransactions#return
# check_status_library_librarytransactions GET    /library/librarytransactions/check_status(.:format) library/librarytransactions#check_status
#                                          POST   /library/librarytransactions/check_status(.:format) library/librarytransactions#check_status
#      manager_library_librarytransactions GET    /library/librarytransactions/manager(.:format)      library/librarytransactions#manager
#                                          POST   /library/librarytransactions/manager(.:format)      library/librarytransactions#manager
#              library_librarytransactions GET    /library/librarytransactions(.:format)              library/librarytransactions#index
#                                          POST   /library/librarytransactions(.:format)              library/librarytransactions#create
#           new_library_librarytransaction GET    /library/librarytransactions/new(.:format)          library/librarytransactions#new
#          edit_library_librarytransaction GET    /library/librarytransactions/:id/edit(.:format)     library/librarytransactions#edit
#               library_librarytransaction GET    /library/librarytransactions/:id(.:format)          library/librarytransactions#show
#                                          PATCH  /library/librarytransactions/:id(.:format)          library/librarytransactions#update
#                                          PUT    /library/librarytransactions/:id(.:format)          library/librarytransactions#update
#                                          DELETE /library/librarytransactions/:id(.:format)          library/librarytransactions#destroy
#       update_subjects_exam_examquestions GET    /exam/examquestions/update_subjects(.:format)       exam/examquestions#update_subjects
#         update_topics_exam_examquestions GET    /exam/examquestions/update_topics(.:format)         exam/examquestions#update_topics
#                       exam_examquestions GET    /exam/examquestions(.:format)                       exam/examquestions#index
#                                          POST   /exam/examquestions(.:format)                       exam/examquestions#create
#                    new_exam_examquestion GET    /exam/examquestions/new(.:format)                   exam/examquestions#new
#                   edit_exam_examquestion GET    /exam/examquestions/:id/edit(.:format)              exam/examquestions#edit
#                        exam_examquestion GET    /exam/examquestions/:id(.:format)                   exam/examquestions#show
#                                          PATCH  /exam/examquestions/:id(.:format)                   exam/examquestions#update
#                                          PUT    /exam/examquestions/:id(.:format)                   exam/examquestions#update
#                                          DELETE /exam/examquestions/:id(.:format)                   exam/examquestions#destroy
#                    exam_examsubquestions GET    /exam/examsubquestions(.:format)                    exam/examsubquestions#index
#                                          POST   /exam/examsubquestions(.:format)                    exam/examsubquestions#create
#                 new_exam_examsubquestion GET    /exam/examsubquestions/new(.:format)                exam/examsubquestions#new
#                edit_exam_examsubquestion GET    /exam/examsubquestions/:id/edit(.:format)           exam/examsubquestions#edit
#                     exam_examsubquestion GET    /exam/examsubquestions/:id(.:format)                exam/examsubquestions#show
#                                          PATCH  /exam/examsubquestions/:id(.:format)                exam/examsubquestions#update
#                                          PUT    /exam/examsubquestions/:id(.:format)                exam/examsubquestions#update
#                                          DELETE /exam/examsubquestions/:id(.:format)                exam/examsubquestions#destroy
#                       exam_answerchoices GET    /exam/answerchoices(.:format)                       exam/answerchoices#index
#                                          POST   /exam/answerchoices(.:format)                       exam/answerchoices#create
#                    new_exam_answerchoice GET    /exam/answerchoices/new(.:format)                   exam/answerchoices#new
#                   edit_exam_answerchoice GET    /exam/answerchoices/:id/edit(.:format)              exam/answerchoices#edit
#                        exam_answerchoice GET    /exam/answerchoices/:id(.:format)                   exam/answerchoices#show
#                                          PATCH  /exam/answerchoices/:id(.:format)                   exam/answerchoices#update
#                                          PUT    /exam/answerchoices/:id(.:format)                   exam/answerchoices#update
#                                          DELETE /exam/answerchoices/:id(.:format)                   exam/answerchoices#destroy
#                         exam_examanswers GET    /exam/examanswers(.:format)                         exam/examanswers#index
#                                          POST   /exam/examanswers(.:format)                         exam/examanswers#create
#                      new_exam_examanswer GET    /exam/examanswers/new(.:format)                     exam/examanswers#new
#                     edit_exam_examanswer GET    /exam/examanswers/:id/edit(.:format)                exam/examanswers#edit
#                          exam_examanswer GET    /exam/examanswers/:id(.:format)                     exam/examanswers#show
#                                          PATCH  /exam/examanswers/:id(.:format)                     exam/examanswers#update
#                                          PUT    /exam/examanswers/:id(.:format)                     exam/examanswers#update
#                                          DELETE /exam/examanswers/:id(.:format)                     exam/examanswers#destroy
#                         exam_shortessays GET    /exam/shortessays(.:format)                         exam/shortessays#index
#                                          POST   /exam/shortessays(.:format)                         exam/shortessays#create
#                      new_exam_shortessay GET    /exam/shortessays/new(.:format)                     exam/shortessays#new
#                     edit_exam_shortessay GET    /exam/shortessays/:id/edit(.:format)                exam/shortessays#edit
#                          exam_shortessay GET    /exam/shortessays/:id(.:format)                     exam/shortessays#show
#                                          PATCH  /exam/shortessays/:id(.:format)                     exam/shortessays#update
#                                          PUT    /exam/shortessays/:id(.:format)                     exam/shortessays#update
#                                          DELETE /exam/shortessays/:id(.:format)                     exam/shortessays#destroy
#                      exam_booleanchoices GET    /exam/booleanchoices(.:format)                      exam/booleanchoices#index
#                                          POST   /exam/booleanchoices(.:format)                      exam/booleanchoices#create
#                   new_exam_booleanchoice GET    /exam/booleanchoices/new(.:format)                  exam/booleanchoices#new
#                  edit_exam_booleanchoice GET    /exam/booleanchoices/:id/edit(.:format)             exam/booleanchoices#edit
#                       exam_booleanchoice GET    /exam/booleanchoices/:id(.:format)                  exam/booleanchoices#show
#                                          PATCH  /exam/booleanchoices/:id(.:format)                  exam/booleanchoices#update
#                                          PUT    /exam/booleanchoices/:id(.:format)                  exam/booleanchoices#update
#                                          DELETE /exam/booleanchoices/:id(.:format)                  exam/booleanchoices#destroy
#                      exam_booleananswers GET    /exam/booleananswers(.:format)                      exam/booleananswers#index
#                                          POST   /exam/booleananswers(.:format)                      exam/booleananswers#create
#                   new_exam_booleananswer GET    /exam/booleananswers/new(.:format)                  exam/booleananswers#new
#                  edit_exam_booleananswer GET    /exam/booleananswers/:id/edit(.:format)             exam/booleananswers#edit
#                       exam_booleananswer GET    /exam/booleananswers/:id(.:format)                  exam/booleananswers#show
#                                          PATCH  /exam/booleananswers/:id(.:format)                  exam/booleananswers#update
#                                          PUT    /exam/booleananswers/:id(.:format)                  exam/booleananswers#update
#                                          DELETE /exam/booleananswers/:id(.:format)                  exam/booleananswers#destroy
#                               exam_exams GET    /exam/exams(.:format)                               exam/exams#index
#                                          POST   /exam/exams(.:format)                               exam/exams#create
#                            new_exam_exam GET    /exam/exams/new(.:format)                           exam/exams#new
#                           edit_exam_exam GET    /exam/exams/:id/edit(.:format)                      exam/exams#edit
#                                exam_exam GET    /exam/exams/:id(.:format)                           exam/exams#show
#                                          PATCH  /exam/exams/:id(.:format)                           exam/exams#update
#                                          PUT    /exam/exams/:id(.:format)                           exam/exams#update
#                                          DELETE /exam/exams/:id(.:format)                           exam/exams#destroy
#                         new_user_session GET    /users/sign_in(.:format)                            devise/sessions#new
#                             user_session POST   /users/sign_in(.:format)                            devise/sessions#create
#                     destroy_user_session DELETE /users/sign_out(.:format)                           devise/sessions#destroy
#                            user_password POST   /users/password(.:format)                           devise/passwords#create
#                        new_user_password GET    /users/password/new(.:format)                       devise/passwords#new
#                       edit_user_password GET    /users/password/edit(.:format)                      devise/passwords#edit
#                                          PATCH  /users/password(.:format)                           devise/passwords#update
#                                          PUT    /users/password(.:format)                           devise/passwords#update
#                 cancel_user_registration GET    /users/cancel(.:format)                             devise/registrations#cancel
#                        user_registration POST   /users(.:format)                                    devise/registrations#create
#                    new_user_registration GET    /users/sign_up(.:format)                            devise/registrations#new
#                   edit_user_registration GET    /users/edit(.:format)                               devise/registrations#edit
#                                          PATCH  /users(.:format)                                    devise/registrations#update
#                                          PUT    /users(.:format)                                    devise/registrations#update
#                                          DELETE /users(.:format)                                    devise/registrations#destroy
#                                    users GET    /users(.:format)                                    users#index
#                                          POST   /users(.:format)                                    users#create
#                                 new_user GET    /users/new(.:format)                                users#new
#                                edit_user GET    /users/:id/edit(.:format)                           users#edit
#                                     user GET    /users/:id(.:format)                                users#show
#                                          PATCH  /users/:id(.:format)                                users#update
#                                          PUT    /users/:id(.:format)                                users#update
#                                          DELETE /users/:id(.:format)                                users#destroy
#                                     root GET    /                                                   static_pages#home
#                                     help GET    /help(.:format)                                     static_pages#help
#                                    about GET    /about(.:format)                                    static_pages#about
#                                  contact GET    /contact(.:format)                                  static_pages#contact
#                                dashboard GET    /dashboard(.:format)                                static_pages#dashboard
#
