class PagesController < ApplicationController
  @calendar = false
  @drive = false

  def home
  end

  def profile
  end

  def calendar
    @authorised = false
    begin
      client = Signet::OAuth2::Client.new(access_token: session[:access_token])
      calendar_service = Google::Apis::CalendarV3::CalendarService.new
      calendar_service.authorization = client
      @calendar_list = calendar_service.list_calendar_lists
      @authorised = true
    rescue
    end
  end

  def tasks
  end

  def files
    @drive_authorised = false
    begin
      client = Signet::OAuth2::Client.new(access_token: session[:access_token])
      drive_service = Google::Apis::DriveV3::DriveService.new
      drive_service.authorization = client
      # @drive_list = drive_service.
      # @drive_authorised = true
    rescue
    end
  end

  def contacts
  end

  def google_calendar
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
      redirect_uri: url_for(:action => :calendar_callback)
    })
    redirect_to client.authorization_uri.to_s
  end

  def calendar_callback
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: url_for(:action => :calendar_callback),
      code: params[:code]
    })
    response = client.fetch_access_token!
    session[:access_token] = response['access_token']
    redirect_to url_for(:action => :calendar)
  end

  def google_drive
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::DriveV3::AUTH_DRIVE_READONLY,
      redirect_uri: url_for(:action => :drive_callback)
    })
    redirect_to client.authorization_uri.to_s
  end

  def drive_callback
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: url_for(:action => :drive_callback),
      code: params[:code]
    })
    response = client.fetch_access_token!
    session[:access_token] = response['access_token']
    redirect_to url_for(:action => :files)
  end
end
