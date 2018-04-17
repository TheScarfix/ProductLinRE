# frozen_string_literal: true

class FeaturesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_feature,
                only: %i[show edit update destroy copy
                         delete_artifact delete_passage]


  # GET /projects/:project_id/features
  def index
    @project  = Project.find(params[:project_id])
    @features = @project.features.page(params[:page])
  end

  # GET /features/1
  def show
    @artifacts = @feature.artifacts.page(params[:artifacts_page])
    @passages  = @feature.passages.page(params[:passages_page])
  end

  # GET /projects/:project_id/features/new
  def new
    @project = Project.find(params[:project_id])
    @feature = @project.features.build
  end

  # GET /features/1/edit
  def edit
  end

  # POST /projects/:project_id/features
  # POST /features.json
  def create
    @project = Project.find(params[:project_id])
    @feature = @project.features.create(feature_params)
    respond_to do |format|
      if @feature.save
        format.html { redirect_to editor_path(project: @feature.project.id), notice: "Feature was successfully created." }
        format.json { render :show, status: :created, location: @feature }
      else
        format.html { render :new }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /features/1
  # PATCH/PUT /features/1.json
  def update
    if check_user_permission(@feature.project)
      respond_to do |format|
        if @feature.update(feature_params)
          format.html { redirect_to @feature, notice: "Feature was successfully updated." }
          format.json { render :show, status: :ok, location: @feature }
        else
          format.html { render :edit }
          format.json { render json: @feature.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    if check_user_permission(@feature.project)
      project_id = @feature.project_id
      @feature.destroy
      respond_to do |format|
        format.html { redirect_to project_features_path(project_id), notice: "Feature was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  def copy
    project = Project.find(feature_params[:project_id])
    if check_user_permission(project)
      original_feature       = @feature
      new_feature            = original_feature.amoeba_dup
      new_feature.orig_feature_id = original_feature.id
      new_feature.project_id = project.id
      new_feature.name       = "Copy of " + new_feature.name
      new_feature.save
      respond_to do |format|
        format.html { redirect_to editor_index_url(project: project.id), notice: "Feature successfully copied." }
        format.json { head :no_content }
      end
    end
  end

  def delete_artifact
    if check_user_permission(@feature.project)
      @feature.artifacts.delete(feature_params[:artifact_id])
      respond_to do |format|
        format.html { redirect_to @feature, notice: "Artifact successfully deleted from Feature." }
      end
    end
  end

  def delete_passage
    if check_user_permission(@feature.project)
      @feature.passages.delete(feature_params[:passage_id])
      respond_to do |format|
        format.html { redirect_to @feature, notice: "Passage successfully deleted from Feature." }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_feature
    @feature = Feature.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feature_params
    params.require(:feature).permit(:name, :description, :project_id, :artifact_id, :passage_id)
  end
end
