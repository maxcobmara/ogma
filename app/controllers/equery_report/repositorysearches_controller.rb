class EqueryReport::RepositorysearchesController < ApplicationController
  filter_resource_access
  
  def new
    @repositorysearch = Repositorysearch.new
    @reposearch=params[:searchrepotype]
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
    #@repositories = Kaminari.paginate_array(@repositorysearch.repositories.sort_by{|x|[x.document_type, x.document_subtype, x.vessel]}).page(params[:page]).per(10)

    @actual_records=@repositorysearch.repositories
    @repos=[]
    @rep=[]
    @per_vessel=Hash.new
    @actual_records.group_by{|x|x.vessel_class}.sort.each do |vessel_class, mrepositories|
      current_vessel_list=Repository.vessel_class_names[vessel_class.to_i-1]
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
 
  private
   
    def repositorysearch_params
      params.require(:repositorysearch).permit(:title, :vessel, :document_type, :document_subtype, :refno, :publish_date, :total_pages, :copies, :location, :repotype, :classification, [:keyword =>{}], :college_id, [:data =>{}])
    end
   
end
