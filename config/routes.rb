Ogma::Application.routes.draw do
  
  namespace :staff do
    resources :staffs, as: :infos do
      collection do
        get :borang_maklumat_staff
      end
    end
  end

  resources :ptbudgets
  
  namespace :asset do
    resources :assets do
      member do
        get :kewpa4
        get :kewpa5
      end
      collection do
        get   :fixed_assets
        post  :fixed_assets
        get   :inventory
        post  :inventory
      end
    end
  end

  namespace :campus do
    resources :locations do
      member do
        get :kewpa7
      end
    end
    resources :location_damages
  end
  
  resources :events do
    member do
      get :calendar
    end
  end
  
  resources :cofiles
  
  resources :documents
  
  resources :students do
    collection do
      get :autocomplete
    end
  end

    
  namespace :student do
    resources :tenants do
      collection do
        get :room_map
        get :statistics
        get :census
        get  :return_key
        post :return_key
        get  :empty_room
        post :empty_room
      end
    end
  end


  resources :bulletins

  
  namespace :library do
    resources :librarytransactions do
      member do
        get :extend
        get :return
      end
      collection do
        get :check_status
        post :check_status
        get   :manager
        post  :manager
      end
    end
  end
  
  devise_for :users
  resources :users
  root  'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/dashboard', to: 'static_pages#dashboard', via: 'get'
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

# == Route Map (Updated 2014-03-05 22:32)
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
#                                ptbudgets GET    /ptbudgets(.:format)                                ptbudgets#index
#                                          POST   /ptbudgets(.:format)                                ptbudgets#create
#                             new_ptbudget GET    /ptbudgets/new(.:format)                            ptbudgets#new
#                            edit_ptbudget GET    /ptbudgets/:id/edit(.:format)                       ptbudgets#edit
#                                 ptbudget GET    /ptbudgets/:id(.:format)                            ptbudgets#show
#                                          PATCH  /ptbudgets/:id(.:format)                            ptbudgets#update
#                                          PUT    /ptbudgets/:id(.:format)                            ptbudgets#update
#                                          DELETE /ptbudgets/:id(.:format)                            ptbudgets#destroy
#                   kewpa7_campus_location GET    /campus/locations/:id/kewpa7(.:format)              campus/locations#kewpa7
#                         campus_locations GET    /campus/locations(.:format)                         campus/locations#index
#                                          POST   /campus/locations(.:format)                         campus/locations#create
#                      new_campus_location GET    /campus/locations/new(.:format)                     campus/locations#new
#                     edit_campus_location GET    /campus/locations/:id/edit(.:format)                campus/locations#edit
#                          campus_location GET    /campus/locations/:id(.:format)                     campus/locations#show
#                                          PATCH  /campus/locations/:id(.:format)                     campus/locations#update
#                                          PUT    /campus/locations/:id(.:format)                     campus/locations#update
#                                          DELETE /campus/locations/:id(.:format)                     campus/locations#destroy
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
#                                 students GET    /students(.:format)                                 students#index
#                                          POST   /students(.:format)                                 students#create
#                              new_student GET    /students/new(.:format)                             students#new
#                             edit_student GET    /students/:id/edit(.:format)                        students#edit
#                                  student GET    /students/:id(.:format)                             students#show
#                                          PATCH  /students/:id(.:format)                             students#update
#                                          PUT    /students/:id(.:format)                             students#update
#                                          DELETE /students/:id(.:format)                             students#destroy
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
#              library_librarytransactions GET    /library/librarytransactions(.:format)              library/librarytransactions#index
#                                          POST   /library/librarytransactions(.:format)              library/librarytransactions#create
#           new_library_librarytransaction GET    /library/librarytransactions/new(.:format)          library/librarytransactions#new
#          edit_library_librarytransaction GET    /library/librarytransactions/:id/edit(.:format)     library/librarytransactions#edit
#               library_librarytransaction GET    /library/librarytransactions/:id(.:format)          library/librarytransactions#show
#                                          PATCH  /library/librarytransactions/:id(.:format)          library/librarytransactions#update
#                                          PUT    /library/librarytransactions/:id(.:format)          library/librarytransactions#update
#                                          DELETE /library/librarytransactions/:id(.:format)          library/librarytransactions#destroy
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
#
