class TagsController < ApplicationController
  auto_complete_for :tag, :name
  def create
    tag_obj, @ticket = Tag.tag_ticket(params[:tag], @client)
    if @ticket       
      tag_obj.save if tag_obj
      @tags = @ticket.tags.sort_by{|t| t.name}
      render :partial => "tags/list"
    else
      render :text => "Could not add that", :status => 400
    end
  end
end
