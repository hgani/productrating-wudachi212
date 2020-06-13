class ReviewsController < ApplicationController
  before_action do
    @purchase = Purchase.find_by_id(params[:purchase_id])
    case action_name.to_sym
    when :new, :create
      @review = Review.new
    end
  end

  def new
    raise ActionController::RoutingError.new('Not Found') if @purchase.blank?
    if @purchase.review_exist?
      flash[:error] = @review.errors.full_messages.join(', ')
      redirect_to product_purchase_path(@purchase.product_id, @purchase.id)
    end 
  end

  def create
    @purchase = Purchase.find(review_params[:purchase_id])
    @review.assign_attributes(review_params)

    # TODO: Create the record in database
    if @review.save
    else
      flash[:error] = @review.errors.full_messages.join(', ')
    end
    redirect_to product_purchase_path(@purchase.product_id, @purchase.id)
  end

  private
    def review_params
      params.require(:review).permit(:purchase_id, :rating, :comment)
    end
end
