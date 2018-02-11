# frozen_string_literal: true

require "test_helper"

class EditorControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  sign_in users(:one)
  test "should get index" do
    get editor_index_url
    assert_response :success
  end
end
