class UsersController < ApplicationController

    # user can view welcome page once they logged in
    get "/" do
      if is_logged_in?
        redirect '/properties'
      else 
        erb :welcome
      end 
    end

    # only new user will see the signup page
    get "/signup" do
      if is_logged_in?
        redirect to "/properties"
      else 
        erb :"/users/signup"
      end 
    end

    # create a new user account
    post '/signup' do
      @user = User.new(
        first_name: params[:first_name], 
        last_name: params[:last_name], 
        username: params[:username], 
        email: params[:email], 
        # biography: params[:biography],
        password: params[:password]
      )
      params[:seller] == "yes" ? true : false # new user can select to be a seller or buyer
      @user.seller = params[:seller]

      if @user.save
        session[:user_id] = @user.id
        redirect to "/properties"
      else 
        flash[:error] = "all required fields must be entered"
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
    
    # check if user's login info matches what is stored in session using login method defined in app controller
    post '/login' do 
       login
    end 

    # user can log out
    get '/logout' do
      if is_logged_in?
        logout!
        #flash[:message] = "you have successfully logged. see you later!"
      else 
        redirect to "/"
      end 
    end 

    # user can view all buyers and sellers
    get '/users' do 
      @sellers = User.where(seller: true)
      @buyers = User.where(seller: false)
      if is_logged_in?
        erb :"/users/index"
      else 
        flash[:status] = "You are not logged in. Please login to view a list of sellers and buyers"
        redirect to "/login"
      end 
    end 

    # buyer can view offers and offers status
    get '/offers' do
      if is_logged_in?
        @offers = UserProperty.where(user_id: current_user.id)
        if !@current_user.seller
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
            redirect to :"/properies"
        end 
      else 
        flash[:status] = "Please log in"
        redirect to :"/login"
      end 
    end 

    # buyer can update sent offers message
    patch '/update_offers' do
      @current_offers = UserProperty.find_by_id(params[:id].first[0].to_s)
      @current_offers.update(message: params[:offer])
      redirect to :"/offers"
    end 

    # buyer delete only his own offers requests
    delete '/delete_offers' do
      @current_offers = UserProperty.find_by_id(params[:id].first[0].to_s)
      if @current_offers.user_id == current_user.id
          @current_offers.destory
          redirect to "/offers"
      else 
        redirect to "/properties"
      end 
    end 

    # seller can view properties they are selling
    get '/sell' do
      if is_logged_in?
        if current_user.seller
          @properties = Property.all.map {|property| property.id if property.seller_id == current_user.id}
            @my_properties = @properties.compact.map{|property_id| Property.find_by_id(property_id)}
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
    get "/users/:id/edit" do
      if is_logged_in?
        if current_user.id === params[:id].to_i
          erb :"/users/edit"
        else
          redirect to "/users/#{params[:id]}"
        end 
      else 
        redirect to :"/login"
      end 
    end

    # update profile in database
    patch "/users/:id" do
      if current_user.id === params[:id].to_i
        # user must be able to authenticate their current password in order to update their password
        if current_user.authenticate(params[:current_password])
            current_user.update(
              # biography: params[:biography],
              # email: params[:email],
              password: params[:new_password]
            )
            flash[:message] = "Your password has been updated"
            redirect to "/users/#{current_user.id}"
          # otherwise, they can only edit other info other than password
        else 
          current_user.update(
            first_name: params[:first_name], 
            last_name: params[:last_name], 
            username: params[:username], 
            email: params[:email],
            biography: params[:biography]
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
    delete "/users/:id" do
      if current_user.id === params[:id].to_i
        current_user.destory
        flash[:deleted] = "your account has been deleted"
        redirect to "/"
      else 
        flash[:error] = "you are not allowed to delete this account"
        redirect to "/users"
      end 
    end

end
