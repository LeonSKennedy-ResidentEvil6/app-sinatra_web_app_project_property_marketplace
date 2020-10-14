class SessionsController < ApplicationController

    get '/login' do
        erb :"users/login"
    end 

    post '/login' do 
        # raise params[:username].inspect
        session[:username] = params[:username]
        # raise params[:username].inspect
        redirect '/properties'
    end 

end 