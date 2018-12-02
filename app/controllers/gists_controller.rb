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
    @gist = Gist.new
    @submit_label = 'Create Gist'
  end

  def edit
  end

  def create
    @gist = Gist.new(gist_params)

    if @gist.valid?

      @client.create_gist({
        :description => @gist.description,
        :public => @gist.public,
        :files => Hash[@gist.files.map { |file| [file[:name], { content: file[:content] }] }]
      })

      redirect_to action: 'index'
      return
    end

    @path = '/gists/new'
    render :new
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

    def gist_params
      params.require(:gist).permit(:description, :files => [ :name, :content ])
    end
end
