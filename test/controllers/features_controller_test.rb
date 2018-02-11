# frozen_string_literal: true

require "test_helper"

class FeaturesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @feature = features(:delete)
  end

  test "should get index" do
    get project_features_url
    assert_response :success
  end

  test "should get new" do
    get new_project_feature_url
    assert_response :success
  end

  test "should create feature" do
    assert_difference("Feature.count") do
      post project_features_url, params: { feature: { description: @feature.description, name: @feature.name } }
    end

    assert_redirected_to feature_url(Feature.last)
  end

  test "should show feature" do
    get feature_url(@feature)
    assert_response :success
  end

  test "should get edit" do
    get edit_feature_url(@feature)
    assert_response :success
  end

  test "should update feature" do
    patch feature_url(@feature), params: { feature: { description: @feature.description, name: @feature.name } }
    assert_redirected_to feature_url(@feature)
  end

  test "should destroy feature" do
    assert_difference("Feature.count", -1) do
      delete feature_url(@feature)
    end

    assert_redirected_to features_url
  end
end
