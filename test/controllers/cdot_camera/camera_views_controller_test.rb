require 'test_helper'

module CdotCamera
  class CameraViewsControllerTest < ActionController::TestCase
    setup do
      @camera_view = cdot_camera_camera_views(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:camera_views)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create camera_view" do
      assert_difference('CameraView.count') do
        post :create, camera_view: { cdot_view_id: @camera_view.cdot_view_id, description: @camera_view.description, direction: @camera_view.direction, display_order: @camera_view.display_order, image_location: @camera_view.image_location, last_updated_at: @camera_view.last_updated_at, name: @camera_view.name, road_id: @camera_view.road_id, road_name: @camera_view.road_name, source: @camera_view.source }
      end

      assert_redirected_to camera_view_path(assigns(:camera_view))
    end

    test "should show camera_view" do
      get :show, id: @camera_view
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @camera_view
      assert_response :success
    end

    test "should update camera_view" do
      patch :update, id: @camera_view, camera_view: { cdot_view_id: @camera_view.cdot_view_id, description: @camera_view.description, direction: @camera_view.direction, display_order: @camera_view.display_order, image_location: @camera_view.image_location, last_updated_at: @camera_view.last_updated_at, name: @camera_view.name, road_id: @camera_view.road_id, road_name: @camera_view.road_name, source: @camera_view.source }
      assert_redirected_to camera_view_path(assigns(:camera_view))
    end

    test "should destroy camera_view" do
      assert_difference('CameraView.count', -1) do
        delete :destroy, id: @camera_view
      end

      assert_redirected_to camera_views_path
    end
  end
end
