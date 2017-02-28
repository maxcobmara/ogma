class InsurancePoliciesController < ApplicationController
  before_action :set_insurance_policy, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @insurance_policies = InsurancePolicy.all
    respond_with(@insurance_policies)
  end

  def show
    respond_with(@insurance_policy)
  end

  def new
    @insurance_policy = InsurancePolicy.new
    respond_with(@insurance_policy)
  end

  def edit
  end

  def create
    @insurance_policy = InsurancePolicy.new(insurance_policy_params)
    @insurance_policy.save
    respond_with(@insurance_policy)
  end

  def update
    @insurance_policy.update(insurance_policy_params)
    respond_with(@insurance_policy)
  end

  def destroy
    @insurance_policy.destroy
    respond_with(@insurance_policy)
  end

  private
    def set_insurance_policy
      @insurance_policy = InsurancePolicy.find(params[:id])
    end

    def insurance_policy_params
      params.require(:insurance_policy).permit(:insurance_type, :company_id, :policy_no, :college_id, :data)
    end
end
