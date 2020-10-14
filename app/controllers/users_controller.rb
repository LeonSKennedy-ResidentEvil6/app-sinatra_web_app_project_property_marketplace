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

      # user can view properties they have offered to buy && offer status 
    get '/offers' do
      if is_logged_in?
        @offer = 
      end 
    end 


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
