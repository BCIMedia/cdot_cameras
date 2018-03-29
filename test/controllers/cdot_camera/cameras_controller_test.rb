require 'test_helper'

module CdotCamera
  class CamerasControllerTest < ActionController::TestCase
    setup do
      @camera = cdot_camera_cameras(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:cameras)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create camera" do
      assert_difference('Camera.count') do
        post :create, camera: { cdot_camera_id: @camera.cdot_camera_id, description: @camera.description, icon: @camera.icon, latitude: @camera.latitude, longitude: @camera.longitude, name: @camera.name, source: @camera.source, status: @camera.status, weather_station: @camera.weather_station }
      end

      assert_redirected_to camera_path(assigns(:camera))
    end

    test "should show camera" do
      get :show, id: @camera
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @camera
      assert_response :success
    end

    test "should update camera" do
      patch :update, id: @camera, camera: { cdot_camera_id: @camera.cdot_camera_id, description: @camera.description, icon: @camera.icon, latitude: @camera.latitude, longitude: @camera.longitude, name: @camera.name, source: @camera.source, status: @camera.status, weather_station: @camera.weather_station }
      assert_redirected_to camera_path(assigns(:camera))
    end

    test "should destroy camera" do
      assert_difference('Camera.count', -1) do
        delete :destroy, id: @camera
      end

      assert_redirected_to cameras_path
    end
  end
end
