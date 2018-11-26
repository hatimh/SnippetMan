require 'octokit'

class ApplicationController < ActionController::Base
  helper_method :authenticated?
  
  def authenticated?
    session[:access_token]
  end

  def get_client
    client = Octokit::Client.new(
      :client_id => ENV['CLIENT_ID'],
      :client_secret => ENV['CLIENT_SECRET']
    )

    valid = client.check_application_authorization(session[:access_token])

    if !valid
      return nil
    end

    client = Octokit::Client.new(
      :access_token => session[:access_token]
    )
  end
end
