class GistsController < ApplicationController
  before_action :check_auth_status

  def index
    if @client
      @gists = @client.gists.select { |gist| gist.public === false }
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end


  def update
  end


  def destroy
  end

  private
    def check_auth_status
      if authenticated?
        client = get_client

        if client
          @client = client
          return
        end
      end
      
      redirect_to root_path
    end
end
