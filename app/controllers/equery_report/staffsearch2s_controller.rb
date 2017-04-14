class EqueryReport::Staffsearch2sController < ApplicationController
  filter_resource_access
  before_action :set_staffsearch2, only: [:show]
  
  def new
    @staffsearch2 = Staffsearch2.new
  end
  
  def create
    @staffsearch2 = Staffsearch2.new(staffsearch2_params)
    if @staffsearch2.save
      redirect_to equery_report_staffsearch2_path(@staffsearch2)
    else
      render :action => 'new'
    end
  end
  
  def show
    @staffsearch2 = Staffsearch2.find(params[:id])
    ####
    if @staffsearch2.keywords.blank? && @staffsearch2.position==0 && @staffsearch2.staff_grade.blank? && @staffsearch2.position2==0 && @staffsearch2.position3==0
      @positions = []
    else
      @positions = Position.where('staffgrade_id IS NOT NULL AND staff_id IN(?) AND name NOT ILIKE ?', @staffsearch2.staffs.map(&:id), "ICMS%").order( :ancestry_depth)  
      if @staffsearch2.blank_post==1
        @positions_blank_post=[]
        if @staffsearch2.position==1
          @positions_blank_post+= Position.where('staff_id is NULL AND employgrades.group_id=?', 4)
        end
        if @staffsearch2.position2==1 
          @positions_blank_post+= Position.where('staff_id is NULL AND employgrades.group_id=?', 2)
        end
        if @staffsearch2.position3==1
          @positions_blank_post+= Position.where('staff_id is NULL AND employgrades.group_id=?', 1)
        end
        #when staff_grade or keywords is selected (+all service group), -> result must be within selected staff grade
        if !@staffsearch2.staff_grade.blank? 
          @positions_blank_post= Position.where('staff_id is NULL AND staffgrade_id=?', @staffsearch2.staff_grade.to_i)
        end
	if !@staffsearch2.keywords.blank? 
          @positions_blank_post= Position.where('staff_id is NULL AND staffs.name ILIKE(?)', "%#{@staffsearch2.keywords}%")
        end
        @positions+=@positions_blank_post
      end
    end
    ####
  end

   private
   
   # Use callbacks to share common setup or constraints between actions.
    def set_staffsearch2
      @title = Title.find(params[:id])
    end

     # Never trust parameters from the scary internet, only allow the white list through.
     def staffsearch2_params
       params.require(:staffsearch2).permit(:keywords, :position, :staff_grade, :position2, :position3, :blank_post, :college_id, {:data => []})
     end
end
