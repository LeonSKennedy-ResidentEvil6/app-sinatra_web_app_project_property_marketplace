require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  use Rack::Flash
  
  set :session_secret, "secret_properties"
  set :views, Proc.new { File.join(root, "../views/") }

  # user can view welcome page if not logged in
  get '/' do
    if is_logged_in?
        redirect to "/properties"
    else
        erb :welcome
    end
  end

  # HELPER METHODS
  helpers do

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
        flash[:error] = 'Unable to find this user in the system'
        redirect to "/login"
      end 
    end 

    # Find a property based on id
    def find_property(id)
      @find_property ||= Property.find_by_id(id)
    end

    def logout
      if is_logged_in?
        session.clear
        flash[:message] = "you have logged. See you later!"
        redirect to "/login"
      else
        redirect to "/"
      end
    end 

    # show buyer application status
    def application_status(applied_value_num)
      case applied_value_num
        when 0
          "sent"
        when 1
          "accepted"
        else
          "declined"
        end
    end
  end
end