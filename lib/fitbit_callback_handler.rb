# Bundler.require(:default)
require 'sinatra/base'
require 'em-http'
require 'em-http/middleware/oauth'

class FitbitCallbackHandler < Sinatra::Base

# [{
#  "collectionType":"activities",
#  "date":"2010-03-01",
#  "ownerId":"184X36",
#  "ownerType":"user",
#  "subscriptionId":"2345",
# }, ..]

# {:activities=>[], 
#  :goals=>{:activeScore=>1000, :caloriesOut=>2500, :distance=>8.05, :floors=>25, :steps=>10000}, 
#  :summary=>{
#   :activeScore=>278, :activityCalories=>533, :caloriesOut=>2148, 
#   :distances=>[{:activity=>"total", :distance=>1.15}, {:activity=>"tracker", :distance=>1.15},
#    {:activity=>"loggedActivities", :distance=>0}, {:activity=>"veryActive", :distance=>0}, 
#    {:activity=>"moderatelyActive", :distance=>0.83}, {:activity=>"lightlyActive", :distance=>0.29}, 
#    {:activity=>"sedentaryActive", :distance=>0}],
#   :elevation=>33.53, :fairlyActiveMinutes=>38, 
#   :floors=>11, :lightlyActiveMinutes=>115, :marginalCalories=>294, :sedentaryMinutes=>1287, 
#   :steps=>1535, :veryActiveMinutes=>0}}

  post('/callback') do
    fb_events = JSON.parse request.body.string, symbolize_names: true
    puts "fitbit notification: #{fb_events}"
    EM.next_tick do
      update_counts_and_notify_of_changes(fb_events)
    end
    status 204
    ''
  end

  post('/get_last_5_days') do
    user = User.find_by_app_token params[:app_token]
    (0..4).each {|no| get_activities(user, no.days.ago.to_date.iso8601) }
    status 204
    ''
  end

  get('/test_sinatra') { 'hello' }

  # to update to use EM::Iterator as soon as heroku has EM ->v1
  # def update_counts_and_notify_of_changes(fb_events)
  #   old_ranking = current_ranking
  #   pending = fb_events.size
  #   fb_events.each do |event|
  #     next if event[:collectionType] != 'activities' or event[:ownerType] != 'user'
  #     u = User.find_by_fitbit_uid!(event[:ownerId])
  #     get_activities(u, event[:date], proc{puts 'done?'; pending-=1;  if pending==0})
  #   end
  # end

  def update_counts_and_notify_of_changes(fb_events)
    old_ranking = current_ranking
    multi = EventMachine::MultiRequest.new
    fb_events.each do |event|
      next if event[:collectionType] != 'activities' or event[:ownerType] != 'user'
      u = User.find_by_fitbit_uid!(event[:ownerId])
      multi.add event.__id__, get_activities(u, event[:date])
    end
    multi.callback do
      send_updates(old_ranking, current_ranking)
    end
  end
  
  
  def send_updates(old_ranking, new_ranking)
    puts "sending updates"
    new_ranking.each_index do |i|
      difference = i - old_ranking.index(new_ranking[i])
      if difference > 0
        # send gaining message
      elsif difference < 0
        # send losing message
      end
    end
  end
  
  def current_ranking
    stats = User.joins(:activity_days).where('date >= ?', 4.days.ago.to_date).group(:user_id).sum(:steps)
    stats.sort{|a,b| b[1] <=> a[1]}.map{|o| o[0]}
  end

  def get_activities(user, date_str)
    url = "http://api.fitbit.com/1/user/#{user.fitbit_uid}/activities/date/#{date_str}.json"
    conn = EventMachine::HttpRequest.new(url)
    conn.use EventMachine::Middleware::OAuth, user.oauth_config
    http = conn.get
    http.callback do
      info = JSON.parse http.response, symbolize_names: true
      puts info
      user.activity_days.create_or_update(Date.parse(date_str), info[:summary].select{|k| [:steps, :stairs].include?(k)})
    end
    http.errback do
      puts "Failed retrieving user stream. #{user.id} #{date_str}\n #{http.response}"
    end
    http
  end
end
