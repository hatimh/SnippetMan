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
    id = params[:id]

    if id
      @gist = Gist.new(gist_params)
      gist = @client.gist(id)

      if !gist.blank? && @gist.valid?

        @client.edit_gist(gist.id, {
          :description => @gist.description,
          :public => @gist.public,
          :files => Hash[@gist.files.map { |file| [file[:name], { content: file[:content] }] }]
        })

        redirect_to action: 'index'
        return
      end
    end

    render :edit
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
