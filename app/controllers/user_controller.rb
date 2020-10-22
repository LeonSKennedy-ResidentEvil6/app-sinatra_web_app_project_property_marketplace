class UserController < ApplicationController

  # only new user will see the signup page
  get '/signup' do
      if is_logged_in?
          redirect to "/properties"
      else
          erb :"/users/signup"
      end
  end

  # create a new user account
  post '/signup' do
      @user = User.new(
          full_name: params[:full_name], 
          username: params[:username], 
          email: params[:email], 
          password: params[:password]
          )
      params[:seller] == "yes" ? true : false
      @user.seller = params[:seller]

      if @user.save
          session[:user_id] = @user.id
          redirect to "/properties"
      else
          flash[:error] = "Account is not created, please try again"
          redirect to "/signup"
      end
  end

   # current logged user can view properties without re-login; otherwise, user is asked to login
  get '/login' do
      if is_logged_in?
          redirect to "/properties"
      else
          erb :"/users/login"
      end
  end

  # check if user's login info matches what is stored in session using helper method
  post '/login' do
      login
  end

  # user can log out using helper method
  get '/logout' do
      logout
  end

  # user can view all buyers and sellers
  get '/users' do
      @sellers = User.where(seller: true)
      @buyers = User.where(seller: false)

      if is_logged_in?
          erb :"/users/index"
      else
          flash[:status] = "You are not logged in. Please login to view a list of sellers and buyers"
          redirect to :"/login"
      end
  end
  
  # buyer can view offers and offers status
  get '/offered' do

      if is_logged_in?
          @offers = UserProperty.where(user_id: current_user.id)
          if !current_user.seller
              erb :"/properties/my_offers"
          else
              redirect to :"/properties"
          end
      else
          redirect to :"/login"
      end
  end

  # buyer can update offers already sent
  get '/update_offers' do
      if is_logged_in?
          if !current_user.seller
              @offers = UserProperty.where(user_id: current_user.id)
              erb :"/properties/edit_my_offers"
          else
              flash[:error] = "You need to be a buyer to edit this offer"
              redirect to :"/properties"
          end
      else
          flash[:status] = "Please log in"
          redirect to :"/login"
      end
  end

  # Update existing offers
  patch '/update_offers' do
      @current_offers = UserProperty.find_by_id(params[:id].first[0].to_s)
      @current_offers.update(message: params[:message])
      redirect to "/offered"
  end

  # buyer delete only his own offers requests
  delete '/delete_offers' do
      @current_offers = UserProperty.find_by_id(params[:id].first[0].to_s)

      if @current_offers.user_id == current_user.id
          @current_offers.destroy
          redirect to "/offered"
      else
          redirect to "/properties"
      end
  end


   # seller can view properties they are selling
  get '/sell' do
      if is_logged_in?
          if current_user.seller
              @properties = Property.all.map {|property|
                  property.id if property.seller_id == current_user.id}
              @my_properties = @properties.compact.map{|my_property| Property.find_by_id(my_property)}
          
              erb :"/properties/my_properties"
          else
              redirect to "/properties"
          end
      else
          redirect to :"/login"
      end
  end

  # user can view any other particular user by id
  get '/users/:id' do 
      @user = User.find_by_id(params[:id])
      if is_logged_in?
          erb :"/users/show"
      else
          redirect to :"/login"
      end
  end

  # user can edit only his own profile 
  get '/users/:id/edit' do 
      if is_logged_in?
          if current_user.id == params[:id].to_i
              erb :"/users/edit"
          else
              redirect to "/users/#{params[:id]}"
          end
      else
          redirect to :'/login'
      end
  end

  # update user profile
  patch '/users/:id' do
      if current_user.id == params[:id].to_i
          # user must be able to authenticate their current password in order to update their password
          if current_user.authenticate(params[:current_password])
              current_user.update(
                  biography: params[:biography], 
                  email: params[:email], 
                  password: params[:new_password]
                  )
              flash[:message] = "You profile and password has been updated successfully!"
              redirect to "/users/#{current_user.id}"
          # otherwise, they can not change password
          else
              current_user.update(
                  biography: params[:biography], 
                  email: params[:email]
                  )
              flash[:message] = "Your profile has been updated"
              redirect to "/users/#{current_user.id}"
          end
      else
          flash[:error] = "profile is not updated, please try again"
          redirect to "/users/#{params[:id]}"
      end
  end

   # User can delete only their own account
  delete '/users/:id' do
      if current_user.id === params[:id].to_i
          current_user.destroy
          flash[:deleted] = "Your account has been deleted. Sorry you are leaving us!"
          redirect to "/"
      else
          flash[:error] = "You are not authorized to delete this account"
          redirect to "/users"
      end
  end

end