require_dependency "cdot_camera/application_controller"

module CdotCamera
  class CameraViewsController < ApplicationController
    before_action :set_camera_view, only: [:show, :edit, :update, :destroy]

    # GET /camera_views
    def index
      @camera_views = CameraView.all
    end

    # GET /camera_views/1
    def show
    end

    # GET /camera_views/new
    def new
      @camera_view = CameraView.new
    end

    # GET /camera_views/1/edit
    def edit
    end

    # POST /camera_views
    def create
      @camera_view = CameraView.new(camera_view_params)

      if @camera_view.save
        redirect_to @camera_view, notice: 'Camera view was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /camera_views/1
    def update
      if @camera_view.update(camera_view_params)
        redirect_to @camera_view, notice: 'Camera view was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /camera_views/1
    def destroy
      @camera_view.destroy
      redirect_to camera_views_url, notice: 'Camera view was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_camera_view
        @camera_view = CameraView.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def camera_view_params
        params.require(:camera_view).permit(:name, :description, :source, :cdot_view_id, :direction, :image_location, :display_order, :road_name, :road_id, :last_updated_at)
      end
  end
end
