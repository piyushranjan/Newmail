class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    @people = Person.find(:all, :conditions => {:client_id => @client.id}, :limit => 1000, :order => "name")
    @person = @people.first
  end

  def show
    @person = Person.find(params[:id])
    render :partial => "people/vcard"
  end
  
end
