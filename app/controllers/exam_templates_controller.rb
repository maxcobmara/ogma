class ExamTemplatesController < ApplicationController
  before_action :set_exam_template, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @exam_templates = ExamTemplate.all
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
    respond_with(@exam_template)
  end

  def update
    @exam_template.update(exam_template_params)
    respond_with(@exam_template)
  end

  def destroy
    @exam_template.destroy
    respond_with(@exam_template)
  end

  private
    def set_exam_template
      @exam_template = ExamTemplate.find(params[:id])
    end

    def exam_template_params
      params.require(:exam_template).permit(:name, :created_by, :data, :deleted_at)
    end
end
