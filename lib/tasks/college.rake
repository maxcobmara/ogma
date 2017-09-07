namespace :college do
  
  #ref
  #config/unicorn.rb
  #http://jasonseifer.com/2010/04/06/rake-tutorial
  #http://railscasts.com/episodes/66-custom-rake-tasks?autoplay=true
  #https://stackoverflow.com/questions/17823005/rake-task-to-update-a-column-value
  #https://stackoverflow.com/questions/516579/is-there-a-way-to-get-a-collection-of-all-the-models-in-your-rails-app
  #https://stackoverflow.com/questions/20102477/how-to-write-update-all-conditinally-queries-in-rails4
  #https://stackoverflow.com/questions/11011402/get-columns-names-with-activerecord
  #https://gist.github.com/ffmike/296719
  
  desc "All Tables - Check college data"
  task :update_all => :environment do
    conn = ActiveRecord::Base.connection
    #conn.tables.each{|t| puts "#{t} #{t.classify}"}
    # NOTE - t returns "academic_sessions"  (for constantize to works, a model must exist 4 corresponding tables)
    # "academic_sessions".class=> String,
    # "academic_sessions".classify=> "AcademicSession"
    # "academic_sessions".classify.constantize=> AcademicSession(id: integer, semester: string, total_week: integer, created_at: datetime, updated_at: datetime, college_id: integer, data: string) 
    
    cnt=cnt||0
    total_model=0
    w_college=0
    app_dir = File.expand_path("../../..", __FILE__)
    Dir.foreach("#{app_dir}/app/models") do |amodel|  
      if amodel.include?(".rb")
        total_model+=1
        aclass=amodel.gsub(".rb","").classify
	atable=aclass.constantize
        cols=atable.column_names
         if cols.include?("college_id")
	   w_college+=1
	   recs=pick(atable)
	   if recs.count > 0
	     puts "#{cnt+=1}) Table : #{atable} - #{recs.count} records - no college data! "
	     recs.update_all(college_id: pick_college)
	     puts "Records (college_id) added! "
	   end
	 end
      end
    end
    
    puts "Total tables (DB) :#{conn.tables.count}(#{cnt} table w/o college data, updated!) ~ Total models :#{total_model}(all) ~ #{w_college} (with college_id field)"
  end
  
  #sample - $ bundle exec rake TABLE=Staff college:check, $ bundle exec rake college:check
  desc "Check college data of entered table"
  task :check => :environment do 
    a=ENV["TABLE"]
    atable = a.blank? ? StaffShift : a.constantize 
    recs=pick(atable)
    puts "Table : #{atable} have #{recs.count} records without college data!"
  end
  
  #sample - bundle exec rake TABLE=AssetLoss college:update, $ bundle exec rake college:update
  desc "Update college data"
  task :update => :environment do
    a=ENV["TABLE"]
    atable = a.blank? ? StaffShift : a.constantize 
    recs=pick(atable)
    puts "Table : #{atable} have #{recs.count} records without college data!"
    if recs.count > 0
      recs.update_all(college_id: pick_college)
      puts "College data : #{atable} table were successfully updated! "
    else
      puts "No update required!"
    end
  end
  
  def pick(model_class)
    model_class.where(college_id: nil)
  end
  
  def pick_college
    User.order(created_at: :desc).first.college_id
  end
    
end
