class PropertiesController < ApplicationController

  # user can view all properties if they logged in
  get "/properties" do
    if is_logged_in?
      @properties = Property.all
      erb :"/properties/index"
    else 
      "please log in first"
      # add flash extention to generate error message
      redirect '/login'
    end
  end
  
  # user can list a new property for sell once logged in as a seller
  get "/properties/new" do
    if is_logged_in?
      if current_user.seller
        erb :"/properties/new"
      else
        "only a seller should list a new propety to sell"
        # add flash extention to generate error message
        redirect "/properties"
      end 
    else 
      redirect "/login"
    end 
  end

  # new property is created and saved in database upon seller submit data via form
  post "/properties" do
    @new_property = Property.create(
      :address => params[:address],
      :overview => params[:overview],
      :price => params[:price]
    )
    if @new_property.save
      "this course has been added"
      # add flash extention to generate error message
      redirect "/sell"
    else 
      "no course has been added. please try again"
      # add flash extention to generate error message
      redirect "/properties/new"
    end 
  end

  # user can view a particular property
  get "/properties/:id" do
    @property = find_property(params[:id])
    @listed_properties = UserProperty.where(property_id: params[:id])
    @existing_offers = nil

    if is_logged_in?
      if !current_user.seller
        @existing_offers = UserProperty.where("property_id = ? AND user_id = ?", params[:id], current_user.id).first
      end 
      erb :"/properties/show"
    else 
      "User needs to be logged in to view a property"
      # add flash extention to generate error message
      redirect "/login"
    end 
  end

  # seller can update buyer's offer request status
  post '/properties/:id/offers' do 
    @property = find_property(params[:id])
    if current_user.seller && current_user.id === @property.seller.id
      @buyer_offered = UserProperty.find_by_id(params[:applied[0].to_i])
      @buyer_offered.update(applied: params[:applied[2].to_i])

      "buyer's offer status has been updated"
      # add flash extention to generate error message
      redirect to "/properties/#{@property.id}"
    else 
      redirect to "/properties/#{@property.id}"
    end 
  end 

  # seller can edit a property for sell post info
  get "/properties/:id/edit" do
    @property = find_property(params[:id])
    if is_logged_in?
      if current_user.seller && current_user.id === @property.seller_id
        erb :"/properties/edit_property"
      elsif current_user.seller && current_user.id != @property.seller_id
        "you can only edit this property, only the owner seller can!"
        # add flash extention to generate error message
        redirect to "/properties/#{@property.id}"
      else !current_user.seller
        "only a seller can edit a property listing"
        # add flash extention to generate error message
        redirect '/login'
      end 
    end 
  end

  # property listing gets updated once seller is checked to be the legi owner of the property
  patch "/properties/:id" do
    @property = find_property(params[:id])
    @property.update(
      :address => params[:address],
      :overview => params[:overview],
      :price => params[:price]
    )

    if current_user.seller && current_user.id === @property.seller.id
      if @property.save
        "this property info has been updated"
        # add flash extention to generate error message
        redirect to "/properties/#{@property.id}"
      else
        "unsuccessfully updated for this property. please try again"
         # add flash extention to generate error message
        redirect to "/properties/#{@property.id}/edit"
      end 
    else 
      redirect to "/properties/#{@property.id}"
    end 
  end

  # seller can delete his owned properties
  delete "/properties/:id/delete" do
    @property = find_property(params[:id])
    if current_user.id === @property.seller.id
      @property.destroy
      "this property listing has been deleted"
      # add flash extention to generate error message
      redirect '/sell'
    else 
      redirect '/properties'
    end 
  end

  # buyer can update his offers
  post '/properties/:id/offers' do 
    @property = find_property(params[:id])
    @new_offer = UserProperty.create(
      :message => params[:message],
      :user_id => current_user.id,
      :property_id => params[:id]
    )

    if @new_property.save
      "you have just sent a new offer"
      # add flash extention to generate error message
      redirect to "/properties/#{@property.id}"
    else
      "offer is not sent. please try again"
      # add flash extention to generate error message
      redirect to "/properties/#{@property.id}"
    end 
  end 


end
