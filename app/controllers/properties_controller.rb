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


  # contiune working !!!
  
  # user can list a new property for sell once logged in as a seller


  # GET: /properties/new
  get "/properties/new" do
    erb :"/properties/new.html"
  end

  # POST: /properties
  post "/properties" do
    redirect "/properties"
  end

  # GET: /properties/5
  get "/properties/:id" do
    erb :"/properties/show.html"
  end

  # GET: /properties/5/edit
  get "/properties/:id/edit" do
    erb :"/properties/edit.html"
  end

  # PATCH: /properties/5
  patch "/properties/:id" do
    redirect "/properties/:id"
  end

  # DELETE: /properties/5/delete
  delete "/properties/:id/delete" do
    redirect "/properties"
  end
end
