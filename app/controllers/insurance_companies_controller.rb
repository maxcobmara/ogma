class InsuranceCompaniesController < ApplicationController
  before_action :set_insurance_company, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @search = InsuranceCompany.search(params[:q])
    @insurance_companies=@search.result
    @insurance_companies=@insurance_companies.page(params[:page]||1)
    respond_with(@insurance_companies)
  end

  def show
    respond_with(@insurance_company)
  end

  def new
    @insurance_company = InsuranceCompany.new
    respond_with(@insurance_company)
  end

  def edit
  end

  def create
    @insurance_company = InsuranceCompany.new(insurance_company_params)
    @insurance_company.save
    respond_with(@insurance_company)
  end

  def update
    @insurance_company.update(insurance_company_params)
    respond_with(@insurance_company)
  end

  def destroy
    @insurance_company.destroy
    respond_with(@insurance_company)
  end

  private
    def set_insurance_company
      @insurance_company = InsuranceCompany.find(params[:id])
    end

    def insurance_company_params
      params.require(:insurance_company).permit(:short_name, :long_name, :active, :college_id, :data)
    end
end
