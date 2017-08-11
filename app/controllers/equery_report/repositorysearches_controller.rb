class EqueryReport::RepositorysearchesController < ApplicationController
  filter_access_to :new, :create, :new_digital_library, :attribute_check => false
  filter_access_to :show, :attribute_check => true
  
  def new
    @repositorysearch = Repositorysearch.new
  end
  
  def new_digital_library
    @repositorysearch = Repositorysearch.new
  end
  
  def create
    @repositorysearch = Repositorysearch.new(repositorysearch_params)
    if @repositorysearch.save
      redirect_to equery_report_repositorysearch_path(@repositorysearch)
    else
      render action:new
    end
  end
  
  def show
    @repositorysearch = Repositorysearch.find(params[:id])
    if @repositorysearch.repotype=='1'
      @repositories = Kaminari.paginate_array(@repositorysearch.repositories).page(params[:page]).per(10)
    elsif @repositorysearch.repotype=='2'
    
      #@repositories = Kaminari.paginate_array(@repositorysearch.repositories.sort_by{|x|[x.document_type, x.document_subtype, x.vessel]}).page(params[:page]).per(10)

      unless @repositorysearch.vessel.blank? #@search.vessel_search.blank?
        vessel_class_name=[@repositorysearch.vessel]
      else
        vessel_class_name=Repository.vessel_class_names
      end
      @actual_records=@repositorysearch.repositories
      @repos=[]
      @rep=[]
      @per_vessel=Hash.new
      @actual_records.group_by{|x|x.vessel_class}.sort.each do |vessel_class, mrepositories|
        unless @repositorysearch.vessel.blank?  #@search.vessel_search.blank?
          current_vessel_list=vessel_class_name
        else
          current_vessel_list=vessel_class_name[vessel_class.to_i-1]
        end
        #current_vessel_list=vessel_class_name[vessel_class.to_i-1]
        per_vessel=Hash[current_vessel_list.map{|x|[x, Hash["master" => [], "specific" =>[] ]]}]        #per_vessel== list of vessel of each VESSEL CLASS
        for a_vessel in current_vessel_list
          spec_arr=[]
          master_arr=[]
          for repository in mrepositories
            unless repository.vessel.blank? #specific
              spec_arr << repository.id if repository.render_vessel==a_vessel
            else #master
              master_arr << repository.id
            end
          end
          per_vessel[a_vessel]["specific"]=spec_arr
          per_vessel[a_vessel]["master"]=master_arr

          @per_vessel=@per_vessel.merge(per_vessel)
        end
        per_vessel.each do |one_vessel, repo_by_cls|
          repo_by_cls.each do |repo_cls|
            @rep << repo_cls[1] 
            @repos +=Repository.where(id: repo_cls[1]).sort_by{|x|[x.document_type, x.document_subtype, x.title, x.refno]} #sort first
          end
        end
      end
    
      @repositories=Kaminari.paginate_array(@repos).page(params[:page]).per(20)  
      ####
      per_vessel_count2=0
      per_vessel_count_arr=[]
      @per_vessel_count_arr=[]
      @per_vessel_count_arr2=[0]
      @per_vessel.each do |vess, repo_sets|
        per_vessel_count=0
        repo_sets.each do |repo_set|
          per_vessel_count+= repo_set[1].count
          per_vessel_count2+= repo_set[1].count
        end 
        @per_vessel_count_arr << per_vessel_count
        @per_vessel_count_arr2 << per_vessel_count2
      end
      ####
    
    end
  end
 
  private
   
    def repositorysearch_params
      params.require(:repositorysearch).permit(:title, :vessel, :document_type, :document_subtype, :equipment, :refno, :publish_date, :total_pages, :copies, :location, :repotype, :classification, [:keyword =>{}], :college_id, [:data =>{}])
    end
   
end
