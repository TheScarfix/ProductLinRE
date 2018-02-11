# frozen_string_literal: true

class PassagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_passage, only: %i[show edit update destroy
                                       choose_feature add_to_feature]

  # GET /passages
  # GET /passages.json
  def index
    @artifact = Artifact.find(params[:artifact_id])
    @passages = @artifact.passages.page(params[:page])
  end

  # GET /passages/1
  # GET /passages/1.json
  def show
  end

  # GET /passages/new
  def new
    @artifact = Artifact.find(params[:artifact_id])
    @passage  = @artifact.passages.build
  end

  # GET /passages/1/edit
  def edit
  end

  # POST /passages
  # POST /passages.json
  def create
    artifact = Artifact.find(params[:artifact_id])
    @passage = artifact.passages.new(passage_params)
    @passage.attach_passage_file(artifact, passage_params)
    respond_to do |format|
      if @passage.save
        format.html
        redirect_to @passage,
                    notice: t("was_successfully_created", resource:
                        @passage.class.model_name.human)
        format.json { render :show, status: :created, location: @passage }
      else
        format.html { render :new }
        format.json { render json: @passage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /passages/1
  # PATCH/PUT /passages/1.json
  def update
    if check_user_permission(@passage)
      respond_to do |format|
        if @passage.update(passage_params)
          format.html { redirect_to @passage, notice: "Passage was successfully updated." }
          format.json { render :show, status: :ok, location: @passage }
        else
          format.html { render :edit }
          format.json { render json: @passage.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /passages/1
  # DELETE /passages/1.json
  def destroy
    if check_user_permission(@passage)
      artifact_id = @passage.artifact.id
      if @passage.features.empty?
        @passage.destroy
        respond_to do |format|
          format.html { redirect_to artifact_passages_path(artifact_id: artifact_id), notice: "Passage was successfully destroyed." }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to @passage, notice: "Passages that are connected to Features can't be destroyed." }
        end
      end
    end
  end

  def choose_feature
  end

  def add_to_feature
    feature = Feature.find_by_id(passage_params[:feature_id])
    if check_user_permission(feature.project)
      @passage.features << feature
      respond_to do |format|
        format.html { redirect_to feature, notice: "Passage was successfully added to Feature." }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_passage
    @passage = Passage.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def passage_params
    params.require(:passage).permit(:name, :description, :artifact_id, :crop,
                                    :text, :start, :duration, :user_id,
                                    :feature_id)
  end
end
