class PageController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def new
  end

  def index
  	#@page = @graph.get_object("1631974847020962")
  	puts "current user #{current_user.inspect}"
    puts "pages #{@pages.inspect}"

  	@pages = graph.get_connections('me', 'accounts') #page accounts
  end

  def show
    logger.info "parameters : #{params[:id]}" 
    page_token = graph.get_page_access_token(params[:id])
    puts "page_token: #{page_token.inspect}"

	  @page_graph = Koala::Facebook::API.new(page_token)
    @page = @page_graph.get_object("me")
  	@feed_items = @page_graph.get_connection('me', 'feed') 
  end

  def create
    @message = params[:message]
    puts "message : #{@message}"
    puts "current_user : #{current_user.inspect}"
    graph = Koala::Facebook::API.new(current_user.token)
    page_token = graph.get_page_access_token(params[:page_id])
    page_graph = Koala::Facebook::API.new(page_token)

    status = page_graph.put_wall_post(params[:message])
    puts status.inspect

  end

end