require 'spec_helper.rb'
require_relative '../../lib/blueberry/terra.rb'

describe "Terraform" do
  it "can be initialized" do
    @terraform = Terraform.new("web", "test.test.edu")
    expect(@terraform.role).to eql "web"
    expect(@terraform.hostname).to eql "test.test.edu"
  end

end
