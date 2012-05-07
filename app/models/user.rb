class User < ActiveRecord::Base
  has_many :activity_days do
    def create_or_update(date, params)
      find_or_initialize_by_date(date).update_attributes(params)
    end
  end

  validates_uniqueness_of :fitbit_uid

  before_create :add_app_token
  after_create :subscribe_to_fitbit_changes, :connect_friends

  has_and_belongs_to_many :follows, class_name: 'User',
     association_foreign_key: 'following_id', join_table: 'following_users'
  has_and_belongs_to_many :followed_by, class_name: 'User',
    foreign_key: 'following_id', association_foreign_key: 'user_id', join_table: 'following_users'

  scope :add_steps, select('sum(steps) as steps').joins(:activity_days).
    where('date >= ?', 4.days.ago.to_date).group('activity_days.user_id')

  def client
    Fitgem::Client.new(consumer_key: ENV['FITBIT_KEY'], consumer_secret: ENV['FITBIT_SECRET'], 
      token: fitbit_token, secret: fitbit_secret)
  end

  def oauth_config
    { :consumer_key     => ENV['FITBIT_KEY'], :consumer_secret  => ENV['FITBIT_SECRET'],
      :access_token     => fitbit_token, :access_token_secret => fitbit_secret}
  end

  def add_app_token
    self.app_token = SecureRandom.urlsafe_base64(24) # 24 bytes => 32 chars
  end

  def subscribe_to_fitbit_changes
    client.create_subscription type: :activities, subscription_id: id
  end

  def connect_friends
    client.friends['friends'].each do |f|
      if friend = User.find_by_fitbit_uid(f['user']['encodedId'])
        follows << friend
        followed_by << friend
      end
    end
  end
end
