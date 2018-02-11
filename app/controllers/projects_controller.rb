# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]


  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
    if params[:user]
      @projects = @projects.where(user_id: params[:user])
    end
    if params[:search]
      @projects = @projects.where("name LIKE ? OR description LIKE ?",
                                  "%#{params[:search]}%", "%#{params[:search]}%")
                      .order(created_at: :desc).page(params[:page])
    else
      @projects = @projects.order(created_at: :desc).page(params[:page])
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @features = @project.features.page(params[:features_page])
    @products = @project.products.page(params[:products_page])
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to editor_index_path(project: @project.id), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if check_user_permission(@project)
      if project_params[:products_features]
        products_hash = project_params[:products_features].to_hash
        @project.products.each do |product|
          product.update(products_hash[product.id.to_s])
        end
      end
      respond_to do |format|
        if @project.update(project_params.except(:products_features))
          format.html { redirect_back fallback_location: editor_index_path(project: session[:cur_project_id]), notice: "Project was successfully updated." }
          format.json { render :show, status: :ok, location: @project }
        else
          format.html { render :edit }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    if check_user_permission(@project)
      @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_path, notice: "Project was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  # creates a copy of the project
  def copy
    # this duplicates everything but the feature_matrix table
    original_project = Project.find(params[:id])
    new_project      = original_project.amoeba_dup

    # give owner to copying user
    new_project.user = current_user

    # apply changes to database
    new_project.save

    # re-associate feature_matrix table
    original_project.features.each do |original_feature|
      # finding the new id of our feature
      new_feature = new_project.features.find_by orig_feature_id: original_feature.id

      # add one entry for every associated product
      original_feature.products.each do |original_product|
        new_product = new_project.products.find_by orig_product_id: original_product.id
        new_feature.products << new_product
      end
    end

    respond_to do |format|
      format.html { redirect_to editor_index_url(project: new_project.id), notice: "Project successfully copied." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :user_id, :orig_project_id, :description, products_features: [feature_ids: []])
    end
end
