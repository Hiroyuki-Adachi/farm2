require 'spec_helper'

describe System do
  it "値の検証" do
    expect(build(:system_default)).to be_valid
  end
end