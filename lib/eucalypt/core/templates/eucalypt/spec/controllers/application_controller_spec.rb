require_relative '../spec_helper'

describe MainController do
  def app() MainController end

  it "should expect true to be false" do
    expect(true).to be false
  end
end