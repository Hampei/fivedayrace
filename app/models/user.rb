class User < ActiveRecord::Base
  has_many :activity_days do
    def create_or_update(date, params)
      find_or_initialize_by_date(date).update_attributes(params)
    end
  end

  validates_uniqueness_of :fitbit_uid

  before_create do
    self.app_token = SecureRandom.urlsafe_base64(24) # 24 bytes => 32 chars
  end

  after_create do
    client.create_subscription type: :activities, subscription_id: id
  end

  def client
    Fitgem::Client.new(consumer_key: ENV['FITBIT_KEY'], consumer_secret: ENV['FITBIT_SECRET'], 
      token: fitbit_token, secret: fitbit_secret)
  end

  def oauth_config
    {
      :consumer_key     => ENV['FITBIT_KEY'],
      :consumer_secret  => ENV['FITBIT_SECRET'],
      :access_token     => fitbit_token,
      :access_token_secret => fitbit_secret
    }
  end

end
