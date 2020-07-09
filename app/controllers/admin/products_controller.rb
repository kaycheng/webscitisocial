class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: [:edit, :update, :destroy]
  def index
    @products = Product.all.includes(:vendor)
  end

  def new
    @product = Product.new
    @product.skus.build
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "Product created successfully."
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @product.update(product_params)
    redirect_to edit_admin_product_path(@product), notice: "Product updated successfully."
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Product deleted successfully."
  end

  private

  def find_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, 
                                    :vendor_id, 
                                    :list_price, 
                                    :sell_price, 
                                    :on_sell, 
                                    :code,
                                    :description,
                                    skus_attributes: [
                                      :id, :spec, :quantity, :_destroy
                                    ])
  end
end