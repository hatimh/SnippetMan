require 'octokit'

class UsersController < ApplicationController
  helper_method :authenticated?
  
  def authenticated?
    session[:access_token]
  end

  def index
    if authenticated?
      client = Octokit::Client.new(
        :client_id => ENV['CLIENT_ID'],
        :client_secret => ENV['CLIENT_SECRET']
      )

      valid = client.check_application_authorization(session[:access_token])

      if (!valid)
        return
      end

      client = Octokit::Client.new(
        :access_token => session[:access_token]
      )

      @name = client.user.name
    end
  end

  def authenticate
    # Provide a state string key for cross-site protection
    session[:state] = SecureRandom.base64

    client = Octokit::Client.new

    url = client.authorize_url(ENV['CLIENT_ID'],
      :scope => ENV['CLIENT_SCOPE'],
      :state => session[:state],
    )

    redirect_to url
  end

  def callback
    code = request.query_parameters[:code]
    state = request.query_parameters[:state]

    if code && state
      if (request.query_parameters[:state] != session[:state])
        redirect_to root_path
        return
      end

      result = Octokit.exchange_code_for_token(code, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'])
      access_token = result[:access_token]

      if access_token
        session[:access_token] = access_token
      end
    end

    redirect_to action: 'index'
  end

  def logout
    session[:access_token] = nil
    redirect_to root_path
  end  
end
