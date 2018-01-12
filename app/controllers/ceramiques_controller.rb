class CeramiquesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @dev_redirection = "https://creermonecommerce.fr"
    @ceramiques = Ceramique.all
    Offer.where(showcased: true).first ? (Offer.where(showcased: true).first.ceramiques.present? ? @front_offer = Offer.all.where(showcased: true).first : nil) : nil
    @front_offer ? @ceramiques_to_display_in_offer = Ceramique.all.where(offer: @front_offer) : nil
    clean_orders
    uniq_categories
    if params[:all].present?
      @ceramiques
    else
      filter_by_category if params[:categories].present?
      filter_by_price if params[:prix_max].present?
      filter_by_offer if params[:offer].present?
    end
    @twitter_url = request.original_url.to_query('url')
  end

  def show
    @dev_redirection = "https://creermonecommerce.fr/produits"
    clean_orders
    @ceramique = Ceramique.friendly.find(params[:id])
    @same_category_products = @ceramique.category.ceramiques - [@ceramique]
    @twitter_url = request.original_url.to_query('url')
  end

  private

  def clean_orders
    Order.all.each do |order|
      if (Time.now - order.created_at)/60/60 > ENV['BASKETDURATION'].to_f && order.state == "pending" && order.lesson.blank?
        order.basketlines.each do |basketline|
          ceramique = basketline.ceramique
          ceramique.update(stock: ceramique.stock + basketline.quantity)
        end
        order.update(state: "lost")
        session[:order] = nil
      end
    end
  end

  def uniq_categories
    @categories = @ceramiques.map do |ceramique|
      ceramique.category.name
    end
    @categories = @categories.uniq.sort
  end

  def filter_by_category
    @ceramiques = []
    params[:categories].each do |categorie|
      @ceramiques << Ceramique.all.where(category_id: Category.find_by(name: categorie).id)
    end
    @ceramiques = @ceramiques.flatten(2)
  end

  def filter_by_price
    @ceramiques = @ceramiques.select {|ceramique| ceramique.price_cents <= params[:prix_max].to_i * 100 }
  end

  def filter_by_offer
    @ceramiques = @ceramiques.select {|ceramique| ceramique.offer == @front_offer}
  end
end

