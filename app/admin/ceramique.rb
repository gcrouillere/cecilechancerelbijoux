ActiveAdmin.register Ceramique, as: 'Bijoux' do
  permit_params :name, :description, :stock, :weight, :category_id, :price_cents, photos: []
  menu priority: 1

  index do
    column :name
    column :description
    column :stock
    column :weight
    column "Catégorie" do |ceramique|
      ceramique.category.name
    end
    column :price_cents
    column "Nb de ventes - CA" do |ceramique|
      total = 0
      sum = 0
      ceramique.basketlines.each do |basketline|
        if basketline.order.state == "paid"
          total += basketline.quantity
        end
      end
      sum = total * ceramique.price
      "#{total} - #{sum} €"
    end
    actions
  end

  form do |f|
  f.inputs "" do
    f.input :name
    f.input :description
    f.input :stock
    f.input :weight, :hint => "Poids en grammes"
    f.input :category
    f.input :price_cents, :hint => "Prix en centimes d'euros. Ex: entrez 1200 pour un prix de 12 €"
    f.input :photos, :as => :formtastic_attachinary, :hint => "Sélectionnez les photos du produit. Maintenez Ctrl appuyé pour en sélectionner plusieurs."
    # , :hint => image_tag(f.object.photos[0].path)
  end
  f.actions
 end

show do |ceramique|
  attributes_table do
    row :name
    row :description
    row :stock
    row :weight
    row "Categorie" do |ceramique|
      ceramique.category.name
    end
    row :price_cents
    row :images do |ceramique|
      ceramique.photos.each do |photo|
        span img(src: "http://res.cloudinary.com/dbhsa0hgf/image/upload/#{photo.path}")
      end
    end
  end
 end

 csv do
    column :name
    column :description
    column :stock
    column :weight
    column "Catégorie" do |ceramique|
      ceramique.category.name
    end
    column :price_cents
    column "Nb de ventes - CA" do |ceramique|
      total = 0
      sum = 0
      ceramique.basketlines.each do |basketline|
        if basketline.order.state == "paid"
          total += basketline.quantity
        end
      end
      sum = total * ceramique.price
      "#{total} - #{sum} €"
    end
 end

 controller do

    def create
    super do |format|
      redirect_to admin_bijoux_path and return if resource.valid?
    end
  end

  def destroy
    flash[:notice] = "#{ENV['MODEL'][0...-1].capitalize} supprimé"
    super do |format|
      redirect_to admin_bijoux_path and return
    end
  end

  def update
    super do |format|
      redirect_to admin_bijoux_path and return if resource.valid?
    end
  end

  end

end
