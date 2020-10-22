class PropertyController < ApplicationController
    
  # user can view all properties
  get '/properties' do
      if is_logged_in?
          @properties = Property.all
          erb :"/properties/index"
      else
          flash[:error] = "please log in first"
          redirect to :"/login"
      end
  end

  # seller can list a new property for sell
  get '/properties/new' do
      if is_logged_in?
          if current_user.seller
              erb :"/properties/new"
          else
              flash[:error] = "Only a seller can list a new propety"
              redirect to "/properties"
          end
      else
          redirect to :"/login"
      end
  end

  # new property is created and saved in database upon submission
  post '/properties' do
      @new_property = Property.create(
       address: params[:address], 
       picture: params[:picture], 
       overview: params[:overview],
       price: params[:price],
       seller_id: session[:user_id]
      )
      
      if @new_property.save 
          flash[:message] = "This property has been listed"
          redirect to "/sell"
      else
          flash[:error] = "No property has been added. please try again"
          redirect to "/properties/new"
      end
  end

  # user can view a particular property
  get '/properties/:id' do
      @property = find_property(params[:id])
      @property_offers = UserProperty.where(property_id: params[:id])
      @existing_application = nil

      if is_logged_in?
          if !current_user.seller
          @existing_application = UserProperty.where("property_id = ? AND user_id = ?", params[:id], current_user.id).first
          end

          erb :"/properties/show"
      else
          flash[:error] = "please log in to view this property"
          redirect to "/login"
      end
  end

  # seller can view and change buyer's offer request status
  post '/properties/:id/offers' do
      @property = find_property(params[:id])
      if current_user.seller && current_user.id === @property.seller.id
          @current_offer = UserProperty.find_by_id(params[:applied][0].to_i)
          @current_offer.update(applied: params[:applied][2].to_i)

          flash[:message] = "Buyer's application status has been updated"
          redirect to "/properties/#{@property.id}"
      else
          redirect to "/properties/#{@property.id}"
      end
  end

  # seller can edit a property info
  get '/properties/:id/edit' do
      @property = find_property(params[:id])
      if is_logged_in?
          if current_user.seller && current_user.id == @property.seller_id
              erb :"/properties/edit_property"
          elsif current_user.seller && current_user.id != @property.seller_id
              flash[:error] = 'seller can edit his own listed property'
              redirect to "/properties/#{@property.id}"
          else !current_user.seller
              flash[:error] = "Only a seller can edit a property listing"
              redirect to :"/login"
          end
      end
  end

  # property gets updated
  patch '/properties/:id' do
      @property = find_property(params[:id])
      @property.update(
          address: params[:address], 
          picture: params[:picture], 
          overview: params[:overview],
          price: params[:price]
          )
      if current_user.seller && current_user.id == @property.seller.id
          if @property.save
              flash[:message] = 'This property profile has been updated'
              redirect to "/properties/#{@property.id}"
          else 
              flash[:message] = "Can't update this property profile, please try again"
              redirect to "/properties/#{@property.id}/edit"
          end
      else
          redirect to "/properties/#{@property.id}"
      end
  end

  # seller can delete owned properties
  delete '/properties/:id' do
      @property = find_property(params[:id])
      if current_user.id == @property.seller.id
          @property.destroy
          flash[:deleted] = 'This property is now removed'
          redirect to "/sell"
      else
          redirect to "/properties"
      end
  end

  # buyer can update own offer application
  post '/properties/:id/application' do
      @property = find_property(params[:id])
      @new_offer = UserProperty.create(
          message: params[:message], 
          user_id: current_user.id, 
          property_id: params[:id]
          )
      if @new_offer.save
          flash[:message] = "Offer status has been updated for your application"
          redirect to "/properties/#{@property.id}"
      else 
          flash[:error] = "Failed to update the offer, please try again"
          redirect to "/properties/#{@property.id}"
      end
  end

end