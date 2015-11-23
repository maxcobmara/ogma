class Exam::ExamanalysesController < ApplicationController
  filter_access_to :index,:attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_examanalysis, only: [:show, :edit, :update, :destroy]
  before_action :set_index_index2_data, only: [:index, :index2]
  
  def index
    respond_to do |format|
      if @examanalyses
        format.html # index.html.erb
        format.xml  { render :xml => @examanalyses }
      else
        format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+(t 'exam.title')+" - "+(t 'exam.examanalysis.title'))}
        format.xml  { render :xml => @examanalyses.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  
  private 
  
  # Use callbacks to share common setup or constraints between actions.
    def set_examanalysis
      @examanalysis = Examanalysis.find(params[:id])
    end
    
    def set_index_index2_data
      position_exist = @current_user.userable.positions
      roles= @current_user.roles.pluck(:authname)
      @is_admin=true if roles.include?("administration")
      posbasiks=["Pos Basik", "Diploma Lanjutan", "Pengkhususan"]
      @common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
      if position_exist && position_exist.count > 0
        lecturer_programme = @current_user.userable.positions[0].unit
        unless lecturer_programme.nil?
          programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  if posbasiks.include?(lecturer_programme)==false
        end
        unless programme.nil? || programme.count==0
          programme_id = programme.try(:first).try(:id)
        else
          tasks_main = @current_user.userable.positions[0].tasks_main
          if @common_subjects.include?(lecturer_programme) 
            programme_id ='1'
          elsif posbasiks.include?(lecturer_programme) && tasks_main!=nil
            allposbasic_prog = Programme.where(course_type: posbasiks).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
            for basicprog in allposbasic_prog
              lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
            end
            programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
          elsif @is_admin==true
            programme_id='0'# if @current_user.roles.pluck(:authname).include?("administration")
          else
            leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
            if leader_unit
              programme_id = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first.id
            end
          end
        end
        #INDEX use
        @search = Examanalysis.search(params[:q])
        @examanalyses = @search.result.search2(programme_id)
        @examanalyses = @examanalyses.page(params[:page]||1)
        #INDEX2 use
#         @search2 = Resultline.search(params[:q])
#         @resultlines = @search2.result.search2(programme_id) 
#         @resultlines = @resultlines.sort_by(&:student_id)#order(student_id: :asc)
#         @resultlines = Kaminari.paginate_array(@resultlines).page(params[:page]||1) #@resultlines.page(params[:page]||1)
#         @progid=programme_id
      end
    end
end