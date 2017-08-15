class EqueryReport::PtdosearchesController < ApplicationController
  filter_resource_access
  
  def new
    @ptdosearch = Ptdosearch.new
    
#Department part - hide 29April2015---listing as staffattendancesearch
#     progdip_name = Programme.find(:all, :conditions => ['course_type=?', 'Diploma'], :order => 'name ASC').map(&:name).uniq.compact
#     progbasic_name=Programme.find(:all, :conditions => ['course_type IN(?)', ['Diploma Lanjutan', 'Pos Basik', 'Pengkhususan']], :order => 'name ASC').map(&:name).uniq.compact
#     other_department_name=Position.find(:all, :conditions => ['unit is not null and unit NOT IN (?) and unit NOT IN (?)', ['Diploma Lanjutan', 'Pos Basik', 'Pengkhususan'], progdip_name], :order => 'unit ASC').map(&:unit).uniq.compact 
#     @department_list=(other_department_name+progdip_name+progbasic_name).sort

  end

  def create
    @ptdosearch = Ptdosearch.new(ptdosearch_params)
      if @ptdosearch.save
        redirect_to equery_report_ptdosearch_path(@ptdosearch)
      else
        render "new"
        #sample: redirect_to new_ptdosearch_path(@ptdosearch,  :searchptdotype =>'1')
      end
  end
 
  def show
    @ptdosearch = Ptdosearch.find(params[:id])
    @firstdate=Ptschedule.order(start: :asc).first.start
    @lastdate=Ptschedule.order(start: :asc).last.start
  end
  
  
  private
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def ptdosearch_params
      params.require(:ptdosearch).permit(:searchby_post_id, :department, :staff_name, :staff_id, :icno, :schedulestart_start, :schedulestart_end, :college_id, [:data => {}])
    end
    
end