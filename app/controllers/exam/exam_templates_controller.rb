class Exam::ExamTemplatesController < ApplicationController
  filter_resource_access
  before_action :set_exam_template, only: [:show, :edit, :update, :destroy]
  before_action :set_index_data, only: [:index]

  respond_to :html

  def index
    @search = ExamTemplate.search(params[:q])
    @exam_templates = @search.result.search2(@programme_id).order('name ASC, created_by ASC')
    @exam_templates = @exam_templates.page(params[:page]||1)
    respond_with(@exam_templates)
  end

  def show
    respond_with(@exam_template)
  end

  def new
    @exam_template = ExamTemplate.new
    respond_with(@exam_template)
  end

  def edit
  end

  def create
    @exam_template = ExamTemplate.new(exam_template_params)
    @exam_template.save
    respond_with(:exam, @exam_template)
  end

  def update
    @exam_template.update(exam_template_params)
    respond_with(:exam, @exam_template)
  end

  def destroy
    if @exam_template.destroy
      redirect_to(exam_exam_templates_url)
    else
      respond_with(:exam, @exam_template)
    end
  end

  private
    def set_exam_template
      @exam_template = ExamTemplate.find(params[:id])
    end

    def set_index_data
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
            if roles.include?("programme_manager")
              programme_id='2'
            else
              allposbasic_prog = Programme.where(course_type: posbasiks).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
              for basicprog in allposbasic_prog
                lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
              end
              programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
            end
          elsif @is_admin==true
            programme_id='0'# if @current_user.roles.pluck(:authname).include?("administration")
          else
            leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
            if leader_unit
              programme_id = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first.id
            end
          end
        end
        @programme_id=programme_id
      end
    end

    def exam_template_params
      #@allowed_types = DropDown::QTYPE.collect(&:last).map!(&:downcase)
      #params.require(:exam_template).permit(:name, :created_by, :deleted_at, {:question_count => @allowed_types})
      #TODO tighten security as above
      params.require(:exam_template).permit!
    end
end
