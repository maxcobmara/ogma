class EqueryReport::Staffsearch2sController < ApplicationController
  filter_resource_access
  
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
    
    #@positions=Position.where(staff_id: @staffsearch2.staffs.map(&:id))
    
#     if @staffsearch2.keywords.blank? && @staffsearch2.position==0 && @staffsearch2.staff_grade.blank? && @staffsearch2.position2==0 && @staffsearch2.position3==0
#       #@positions = []
# #      @positions=Position.joins(:staffgrade).where('staffgrade_id IS NOT NULL AND staff_id IN(?) AND positions.name NOT ILIKE ?', @staffsearch2.staffs.map(&:id), "ICMS%").order( :ancestry_depth)  
#     else
# #       @positions = Position.where('staffgrade_id IS NOT NULL AND staff_id IN(?) AND name NOT ILIKE ?', @staffsearch2.staffs.map(&:id), "ICMS%").order( :ancestry_depth)  
#       @p1=@positions
#       if @staffsearch2.blank_post==1
#         @positions_blank_post=[]
#         if @staffsearch2.position==1
#           #@positions_blank_post+= Position.joins(:staffgrade).where('staff_id is NULL AND employgrades.group_id=?', 4)
# 	  @positions_blank_post=@positions.joins(:staffgrade).where('staff_id is NULL AND employgrades.group_id=? AND positions.name not ilike ?', 4, "%delete%")
#         end
#         if @staffsearch2.position2==1 
#           #@positions_blank_post+= Position.joins(:staffgrade).where('staff_id is NULL AND employgrades.group_id=?', 2)
# 	  @positions_blank_post=@positions.joins(:staffgrade).where('staff_id is NULL AND employgrades.group_id=? AND positions.name not ilike ?', 2, "%delete%")
#         end
#         if @staffsearch2.position3==1
#           #@positions_blank_post+= Position.joins(:staffgrade).where('staff_id is NULL AND employgrades.group_id=?', 1)
# 	  @positions_blank_post=@positions.joins(:staffgrade).where('staff_id is NULL AND employgrades.group_id=? AND positions.name not ilike ?', 1, "%delete%")
#         end
#         #when staff_grade or keywords is selected (+all service group), -> result must be within selected staff grade
#         if !@staffsearch2.staff_grade.blank? 
#           @positions_blank_post= Position.where('staff_id is NULL AND staffgrade_id=?', @staffsearch2.staff_grade.to_i)
#         end
# 	if !@staffsearch2.keywords.blank? 
#           @positions_blank_post= Position.where('staff_id is NULL AND staffs.name ILIKE(?)', "%#{@staffsearch2.keywords}%")
#         end
#         #@positions+=@positions_blank_post
#       end
#     end
    ####
    #@positions=Position.where(staff_id: @staffsearch2.staffs.map(&:id)).uniq
    
  end

   private

     # Never trust parameters from the scary internet, only allow the white list through.
     def staffsearch2_params
       params.require(:staffsearch2).permit(:keywords, :position, :staff_grade, :position2, :position3, :blank_post, :college_id, {:data => []})
     end
end
