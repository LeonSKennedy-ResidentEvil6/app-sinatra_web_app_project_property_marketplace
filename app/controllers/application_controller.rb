require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  use Rack::Flash, :sweep => true

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret_properties"
  end

  # set flash message
  post '/message' do
    @message = Message.create params[:message]
    if @message.save
      flash[:success] = "Message saved successfully."
    else
      flash[:error] = "Invalid message"
    end
    redirect '/'
  end

  # helper method
  helpers do 

  def flash_types
    [:success, :notice, :warning, :error]
  end

  # check if user is logged in
  def is_logged_in?
    !!current_user # double negation returns true || false value
  end 

  # look up current user stored in session using id
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end 

  def login
    # check if the user knows the username && password can be authenticated
    # if so, set the session
    # otherwise, user is redirect to login page
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/properties"
    else 
      flash[:error] = "unable to find this user in the system"
      redirect to "/login"
    end 
  end 

    def logout!
      session.clear
    end 

    # find a property by id
    def find_property(id)
      @property ||= Property.find_by_id(id)
    end 

    # show offer status
    def offer_status(applied_value_num)
      case applied_value_num
        when 0
          "pending"
        when 1
          "accepted"
        else
          "declined"
      end 
    end 
  
  end 
end
