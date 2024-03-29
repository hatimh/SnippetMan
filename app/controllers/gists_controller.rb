class GistsController < ApplicationController
  before_action :check_auth_status

  def index
    if @client
      @gists = @client.gists.select { |gist| gist.public === false }
    end
  end

  def index_starred
    if @client
      @gists = @client.starred_gists.select { |gist| gist.public === false }
    end

    @path = '/gists'
    render :index
  end

  def show
    id = params[:id]

    begin
      gist = @client.gist(id)
      @description = gist.description
      @url = gist.html_url
      @commits = @client.gist_commits(id)
    rescue
      flash.now[:error] = 'No commits found matching provided gist Id.'
    end
  end

  def new
    @gist = Gist.new
  end

  def edit
    id = params[:id]

    if !id.blank?
      gist = @client.gist(id)

      if gist
        @gist = Gist.new(
          :description => gist.description,
          :public => gist.public,
          :files => gist.files.fields.map { |key| { name: key, content: gist.files[key][:content] }}
        )

        @gist.id = gist.id
      end
    end
  end

  def create
    @gist = Gist.new(gist_params)

    if @gist.valid?

      begin
        @client.create_gist({
          :description => @gist.description,
          :public => @gist.public,
          :files => Hash[@gist.files.map { |file| [file[:name], { content: file[:content] }] }]
        })
      rescue
        flash[:error] = 'There was an error creating a new gist.'
      end

      redirect_to action: 'index'
      return
    end

    @path = '/gists/new'
    render :new
  end

  def update
    id = params[:id]

    if id
      @gist = Gist.new(gist_params)
      gist = @client.gist(id)

      if !gist.blank? && @gist.valid?

        begin
          @client.edit_gist(gist.id, {
            :description => @gist.description,
            :public => @gist.public,
            :files => Hash[@gist.files.map { |file| [file[:name], { content: file[:content] }] }]
          })
        rescue
          flash[:error] = 'There was an error editing the gist.'
        end

        redirect_to action: 'index', :flash => flash
        return
      end
    end

    render :edit
  end

  def destroy
    id = params[:id]
    gist = @client.gist(id)

    if gist
      deleted = @client.delete_gist(gist.id)
      
      if !deleted.blank?
        flash.now[:error] = 'There was an error deleting the gist. Ensure you have sufficient permissions.'
      end
    else
      flash.now[:error] = 'Gist with provided Id was not found.'
    end

    redirect_to action: 'index'
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
