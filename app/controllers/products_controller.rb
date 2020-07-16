class ProductsController < ApplicationController
  def index
    @products = Product.order(updated_at: :desc).includes(:vendor).with_attached_cover_image.with_rich_text_description_and_embeds
  end

  def show
    @product = Product.friendly.find(params[:id])
  end
end