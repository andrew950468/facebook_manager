class PageController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  
  def new
    @page_id = params['page_id']
    puts "page_id : #{@page_id}"
  end
  #index is the homepage
  def index

  	#@page = @graph.get_object("1631974847020962")
  	puts "current user #{current_user.inspect}"
    #puts "pages #{@pages.inspect}"
    #get pages on the user's behalf
  	@pages = graph.get_connections('me', 'accounts') #page accounts
  end

  def show
    logger.info "parameters : #{params[:id]}" 
    page_token = graph.get_page_access_token(params[:id])
    puts "page_token: #{page_token.inspect}"

	  @page_graph = Koala::Facebook::API.new(page_token)
    @page = @page_graph.get_object("me")
  	@feed_items = @page_graph.get_connection('me', 'feed') 
    @posts = @page_graph.get_connection('me', 'promotable_posts')
   # @insights = @page_graph.get_connection('me', 'post')
    @unpublished_posts = @posts.select{|x| x['is_hidden'] == true}

    @page_insight = @page_graph.get_connections(params[:id], 'insights', period: 'day')
    #puts "page insights: #{@page_insight.inspect}"
  end

  def create
    publish_status = (params[:publish_status] == "published")

    @message = params[:message]
    puts "message : #{@message}"
    puts "current_user : #{current_user.inspect}"
    graph = Koala::Facebook::API.new(current_user.token)
    page_token = graph.get_page_access_token(params[:page_id])
    page_graph = Koala::Facebook::API.new(page_token)
      
    #pass in messages
    # status = page_graph.put_wall_post(params[:message])
    create_unpublished =  page_graph.put_connections(params[:page_id], 'feed', :message => params[:message], :published => publish_status)
    #puts status.inspect

  end

end