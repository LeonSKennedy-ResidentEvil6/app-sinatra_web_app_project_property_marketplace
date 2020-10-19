class UsersController < ApplicationController


    get "/signup" do
      if is_logged_in?
        redirect '/properties'
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
      @user.seller = params[:seller] == "yes" ? true : false # new user select to be a seller or buyer
      bindging.pry
      if @user.save
        session[:user_id] = @user.id
        redirect '/properties'
      else 
        # can use flash extention to give error messgae instead of printing string
        "please enter all required info"
        redirect '/signup'
      end 
    end 

    # done
    # current logged user can come back and view properties without re-login, otherwise, user needs log in
    get '/login' do
      if is_logged_in?
        redirect '/properties'
      else 
        erb :"/users/login"
      end 
    end   
    
    # done 
    # check if user's login info matches what is stored in session using login method defined in app controller
    post '/login' do 
       login
    end 

    # user can log out from account
    get '/logout' do
      if is_logged_in?
        logout! # method defined in app controller
        # can add flash extension to generate message
        "you have successfully logged. see you later!"
      else 
        redirect '/'
      end 
    end 

    # done
    # user can view all buyers and sellers
    # ideally, buyers can only see sellers && sellers can only see buyers
    get '/users' do 
      @sellers = User.where(seller: true)
      @buyers = User.where(seller: false)
      if is_logged_in?
        erb :"/users/index"
      else 
        # can add flash extention to generate error message here
        redirect '/login'
      end 
    end 

      # continue working the following!!!!

      # buyer can view properties they have offered to buy if logged in or directed to properties list page
      # if user is not logged in, redirect to the login page
    get '/offers' do
      if is_logged_in?
        @offers = UserProperty.where(user_id: current_user.id)
        if !@current_user.seller
          erb :"/properties/my_offers"
        else 
          redirection '/properties'
        end 
      else
        redirect '/login'
      end 
    end 

    # user show form page so they can update offers they sent if they are logged in as a buyer
    # otherwise, redirect them to the login page
    get '/update_offers' do 
      if is_logged_in?
        if !current_user.seller
          @offers = UserProperty.where(user_id: current_user.id)
          erb :"/properties/edit_my_offers"
        else 
          # can add falsh extension here to generate falsh error message
          "You are not a buyer!"
          redirect :'/properies'
        end 
      else 
        # can add falsh extension here to generate falsh error message
        "Please log in to view offers and/or listed properties"
        redirect :"/login"
      end 
    end 

    # buyer's update requests message that get sent
    patch '/update_offers' do
      @offers = UserProperty.find_by(id: params[:id].first[0].to_s)
      @offers.update(:message => params[:message])
      redirect '/offers'
    end 

    # buyer delete offers requests only if his logged matches in the session
    delete '/delete_offers' do
      @offers = UserProperty.find_by(id: params[:id].first[0].to_s)
      if @offers.user_id == current_user.id
        @offers.destory
        redirect '/offers'
      else 
        redirect '/properties'
      end 
    end 

    # seller can view properties they posted
    # if they are logged in as a seller
    get '/sell' do
      if is_logged_in?
        if current_user.seller
          @my_properties_ids = Property.all.map {|property| property.id if property.seller_id == current_user.id}
              @my_properties = @my_properties_ids.map{|property_id| Property.find_by_id(property_id)}
              erb ;"/properties/my_properties"
        else 
            redirect '/properties'
        end 
      else 
        redirect '/login'
      end 
    end 

    # user can view single user, either a buyer or a seller if they are in the database
    # otherwise, the user redirect to login
    get '/users/:id' do 
      @user = User.find_by(id: params[:id])
      if is_logged_in?
        erb :'/users/show'
      else 
        redirect :'/login'
      end 
    end 

    # a user can edit, only his own account info
    # otherwise the user will be redirected to the acount info page
    get "/users/:id/edit" do
      if is_logged_in?
        if current_user.id === params[:id].to_i
          erb :"/users/edit"
        else
          redirect to "/users/#{params[:id]}"
        end 
      else 
        redirect '/login'
      end 
    end

    # update account info in database using params to process user input in the edit.erb form
    patch "/users/:id" do
      if current_user.id === params[:id].to_i
        # user must be able to authenticate their current password in order to update their password
        if current_user.authenticate(params[:current_password])
          current_user.update(password: params[:new_password])
          # can add falsh extention to generate message
          "Your password has been updated"
          redirect to "/users/#{current_user.id}"
          # otherwise, they can only edit other info
        else 
          current_user.update(
            first_name: params[:first_name], 
            last_name: params[:last_name], 
            username: params[:username], 
            email: params[:email],
            biography: params[:biography]
          )
          # can add falsh extention to generate message
          "Your profile has been updated"
          redirect to "/users/#{current_user.id}"
        end
      else 
        "Your attempt to update your info was not successful, please try again"
        # can add falsh extention to generate message
        redirect to "/users/#{params[:id]}"
      end
    end

    # User can delete only their own account
    delete "/users/:id/delete" do
      if current_user.id === params[:id].to_i
        current_user.destory
        "your account has been deleted"
        # can add falsh extention to generate message
        redirect '/'
      else 
        "this account can not be deleted by unauthorized users"
        # can add falsh extention to generate message
        redirect "/users"
      end 
    end

end
