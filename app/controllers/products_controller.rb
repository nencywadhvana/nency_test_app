class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create_product_with_api]
  before_action :fetch_product, only: %i[ destroy edit update show ]

  # GET
  def index
    @products = current_user.products
  end

  def new
    @product = Product.new
  end

  # POST
  def create
    @product = current_user.products.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render 'new'
    end
  end

  def edit
  end

  # PATCH/PUT
  def update
    if @product.present?
      if @product.update_attributes(product_params)
        redirect_to products_path
      else
        render 'edit'
      end
    end
  end

  # GET
  def show
  end

  # DELETE
  def destroy
    @product.destroy if @product.present?
    redirect_to products_path
  end

  # create product With auth API
  def create_product_with_api
    user = User.find_by(authentication_token: params[:authentication_token])
    if user.present?
      product = user.products.new(product_params)
      if product.save
        json_response({success: true,data: {:product => product},message: "Product is created successfully"
          }, 201)
      else
        json_response({success: false,data: {:product => product},errors: product.errors.messages,message: "Validation faild"}, 422)
      end
    else
      json_response({
          success: false,
          message: "Token is invalid"
          }, 400)
    end
  end

  def import_products
    csv_path = params[:file]&.path
    ProductWorker.perform_async(csv_path) if csv_path.present?
    redirect_to root_path
  end

  private

  def fetch_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :user_id)
  end

end
