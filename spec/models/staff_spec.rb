require 'spec_helper'

describe Staff do

  before { @staff = Staff.new(name: "Example User", email: "user@example.com") }

  subject { @staff }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
end