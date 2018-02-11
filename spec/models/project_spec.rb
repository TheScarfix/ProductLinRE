# frozen_string_literal: true

# require 'rspec'
require "rails_helper"
# require_relative '../../app/models/project.rb'


RSpec.describe Project, type: :model do
  it "should do something" do
    testuser = User.new(id: 1, name: "Lola",   email: "lola@mustermann.de", password: "1234aB!e")
    testproject = Project.new(user_id: 1, name: "lola")
    expect(testproject).to be_valid
  end

end
