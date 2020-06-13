class PurchasesController < ApplicationController
  before_action do
    @product = Product.find(params[:product_id])

    case action_name.to_sym
    when :new, :create
      @purchase = @product.purchases.new
    when :show, :edit, :update, :destroy
      @purchase = @product.purchases.find(params[:id])
    end
  end

  def new
  end

  def create
    # TODO: Also decrease product quantity.
    # - For example, if `purchase.quantity` is 3, decrease `product.quantity` by 3
    # - Display an error if `product.quantity` is less than 0 (negative number)

    @purchase.assign_attributes(purchase_params)
    # Check Quantity
    if @purchase.quantity != 0 && @purchase.quantity <= @product.quantity
      if @purchase.save
        # Decrease quantity
        @product.update(quantity: @product.quantity - @purchase.quantity)
      else
        flash[:error] = @purchase.errors.full_messages.join(', ')
      end
    else  
      flash[:error] = "Product is out of stock"
    end 
    redirect_to product_url(@product)

  end

  def edit
    # TODO: Show edit form
  end

  def update
    # TODO: Update record (save to database)

    # cek jumlah stok di produk agar pesanan tidak melebihi jumlah stok
    new_quantity = purchase_params[:quantity].to_i
    if @purchase.quantity != 0 && new_quantity <= @product.quantity+@purchase.quantity
      # update stok produk
      if update_stock
        #update data pembelian
        if @purchase.update(purchase_params)
          redirect_to product_url(@product)
        end 
      end 
    end
    # flash[:error] = @purchase.errors.full_messages.join(', ')
  end

  def destroy
    # TODO: Delete record
    if !@purchase.destroy
      flash[:error] = @purchase.errors.full_messages.join(', ')
    end
    redirect_to product_url(@product)
  end

  def show
  end

  private
    def purchase_params
      params.require(:purchase).permit(:quantity, :delivery_address)
    end

    def update_stock
      case action_name.to_sym
      when :new, :create
        @product.update(quantity: @product.quantity - @purchase.quantity)
      when :edit, :update
        new_quantity = purchase_params[:quantity].to_i
        # Check Quantity
        if @purchase.quantity != new_quantity && new_quantity > @purchase.quantity
          @product.update(quantity: @product.quantity - (new_quantity - @purchase.quantity))
        else
          @product.update(quantity: @product.quantity + (@purchase.quantity - new_quantity))
        end
      end
    end
    
end  
