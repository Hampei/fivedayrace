class SessionsController < ApplicationController
  skip_filter :require_user, :only => [:create, :iphone_login]

#{"provider"=>"fitbit", "uid"=>"", "info"=> {
#   "user"=>{"avatar"=>"http://cache.fitbit.com/AC814559-016A-42D1-C993-1AF63523F4D7_profile_100_square.jpg", "country"=>"GB", "dateOfBirth"=>"1980-04-01", "displayName"=>"Henk", "distanceUnit"=>"METRIC", "encodedId"=>"xxx", "fullName"=>"Henk van der Veen", "gender"=>"MALE", "glucoseUnit"=>"METRIC", "height"=>180, "heightUnit"=>"METRIC", "locale"=>"en_US", "memberSince"=>"2012-03-23", "nickname"=>"Henk", "offsetFromUTCMillis"=>3600000, "strideLengthRunning"=>0, "strideLengthWalking"=>0, "timezone"=>"Europe/London", "waterUnit"=>"en_US", "weight"=>83.3, "weightUnit"=>"METRIC"},
#   "name"=>nil}, 
# "credentials"=>{"token"=>"xxx", "secret"=>"xxx"}, 
# "extra"=>{"access_token"=>#<OAuth::AccessToken:0x0000010153af28 @token="xxx", @secret="xxx", @consumer=#<OAuth::Consumer:0x00000101759db8 @key="xxx", @secret="xxx", @options={:signature_method=>"HMAC-SHA1", :request_token_path=>"/oauth/request_token", :authorize_path=>"/oauth/authorize", :access_token_path=>"/oauth/access_token", :proxy=>nil, :scheme=>:header, :http_method=>:post, :oauth_version=>"1.0", :realm=>"OmniAuth", :site=>"http://api.fitbit.com"}, @http_method=:post,
# "raw_info"=>{"user"=>{"avatar"=>"http://cache.fitbit.com/AC814559-016A-42D1-C993-1AF63523F4D7_profile_100_square.jpg", "country"=>"GB", "dateOfBirth"=>"1980-04-01", "displayName"=>"Henk", "distanceUnit"=>"METRIC", "encodedId"=>"xxx", "fullName"=>"Henk van der Veen", "gender"=>"MALE", "glucoseUnit"=>"METRIC", "height"=>180, "heightUnit"=>"METRIC", "locale"=>"en_US", "memberSince"=>"2012-03-23", "nickname"=>"Henk", "offsetFromUTCMillis"=>3600000, "strideLengthRunning"=>0, "strideLengthWalking"=>0, "timezone"=>"Europe/London", "waterUnit"=>"en_US", "weight"=>83.3, "weightUnit"=>"METRIC"}}}}

  def iphone_login
    session['iphone_login'] = true
    redirect_to '/auth/fitbit'
  end

  def create
    auth = request.env["omniauth.auth"]
    auth['uid'] = auth.info.user.encodedId
    puts 'got to sessions.create ' + auth.to_hash.to_s
    
    user = User.find_by_fitbit_uid(auth.uid) || create_user_with_omniauth(auth)

    if session['iphone_login']
      redirect_to "token://#{user.app_token}"
    else
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Signed in!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

private

  def create_user_with_omniauth(auth)
    User.create!(name: auth.info.user.displayName, avatar: auth.info.user.avatar,
      fitbit_uid: auth.uid,
      fitbit_token: auth.credentials.token, fitbit_secret: auth.credentials.secret)
  end
end
