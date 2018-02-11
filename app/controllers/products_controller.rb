# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]


  # GET /products
  # GET /products.json
  def index
    @project  = Project.find(params[:project_id])
    @products = @project.products.page(params[:page])
  end

  # GET /products/1
  # GET /products/1.json
  def show
    respond_to do |format|
      format.html
      format.zip do
        Tempfile.open("zipfile") do |tempfile|
          @product.create_zip(tempfile)
          send_file tempfile, filename: "#{@product.name}.zip"
        end
      end
    end
  end

  # GET /products/new
  def new
    @project = Project.find(params[:project_id])
    @product = @project.products.build
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    project = Project.find(params[:project_id])
    if check_user_permission(project)
      @product = project.products.new(product_params)
      respond_to do |format|
        if @product.save
          format.html { redirect_to @product, notice: "Product was successfully created." }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    if check_user_permission(@product.project)
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to @product, notice: "Product was successfully updated." }
          format.json { render :show, status: :ok, location: @product }
        else
          format.html { render :edit }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if check_user_permission(@product.project)
      @product.destroy
      respond_to do |format|
        format.html do
          redirect_to project_products_url(project_id: session[:cur_project_id]),
                      notice: "Product was successfully destroyed."
        end
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :project_id,
                                      feature_ids: [])
    end
end
