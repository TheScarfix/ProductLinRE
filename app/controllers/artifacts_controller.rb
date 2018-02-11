# frozen_string_literal: true

class ArtifactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artifact, only: %i[show edit update destroy
                                        choose_feature add_to_feature]

  # GET /artifacts
  # GET /artifacts.json
  def index
    @artifacts = Artifact.all
    if params[:user]
      @artifacts = @artifacts.where(user_id: params[:user])
    end
    if params[:project]
      @artifacts = Artifact.where(id: Project.find_by_id(params[:project]).list_artifact_ids)
    end
    if params[:search]
      @artifacts = @artifacts.where("name LIKE ? OR description LIKE ?",
                                    "%#{params[:search]}%",
                                    "%#{params[:search]}%")
                       .order(created_at: :desc).page(params[:page])
    else
      @artifacts = @artifacts.order(created_at: :desc).page(params[:page])
    end
  end


  # GET /artifacts/1
  # GET /artifacts/1.json
  def show
  end

  # GET /artifacts/new
  def new
    @artifact = Artifact.new
  end

  # GET /artifacts/1/edit
  def edit
  end

  # POST /artifacts
  # POST /artifacts.json
  def create
    @artifact = Artifact.new(artifact_params)

    respond_to do |format|
      if @artifact.save
        format.html { redirect_to @artifact, notice: "Artifact was successfully created." }
        format.json { render :show, status: :created, location: @artifact }
      else
        format.html { render :new }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artifacts/1
  # PATCH/PUT /artifacts/1.json
  def update
    if check_user_permission(@artifact)
      respond_to do |format|
        if @artifact.update(artifact_params)
          format.html { redirect_to @artifact, notice: "Artifact was successfully updated." }
          format.json { render :show, status: :ok, location: @artifact }
        else
          format.html { render :edit }
          format.json { render json: @artifact.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /artifacts/1
  # DELETE /artifacts/1.json
  def destroy
    if check_user_permission(@artifact)
      if @artifact.features.empty?
        @artifact.destroy
        respond_to do |format|
          format.html { redirect_to artifacts_url, notice: "Artifact was successfully destroyed." }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to @artifact, notice: "Artifacts that are connected to Features can't be destroyed." }
        end
      end
    end
  end

  def choose_feature
  end

  def add_to_feature
    feature = Feature.find_by_id(artifact_params[:feature_id])
    if check_user_permission(feature.project)
      @artifact.features << feature
      respond_to do |format|
        format.html { redirect_to feature, notice: "Artifact was successfully added to Feature." }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artifact
      @artifact = Artifact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artifact_params
      params.require(:artifact).permit(:name, :description, :file, :user_id,
                                       :feature_id)
    end
end
