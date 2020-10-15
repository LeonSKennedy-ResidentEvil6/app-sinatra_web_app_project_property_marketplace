class UsersController < ApplicationController

    # done
    get "/signup" do
      if is_logged_in?
        redirect '/properties'
      else 
        erb :"/users/signup"
      end 
    end

    # done
    # create a new user
    post '/signup' do
      @user = User.new(
        first_name: params[:first_name], 
        last_name: params[:last_name], 
        username: params[:username], 
        email: params[:email], 
        password: params[:password]
      )
      @user.seller = params[:seller] == "yes" ? true : false # new user select to be a seller or buyer
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
        if @current_user.seller
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
      @offers = UserProperty.find_by(id: params[;id].first[0].to_s)
      if @offers.user_id == current_user.id
        @offers.destory
        redirect '/offers'
      else 
        redirect '/properties'
      end 
    end 

    # seller





  # POST: /users
  post "/users" do
    redirect "/users"
  end

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
