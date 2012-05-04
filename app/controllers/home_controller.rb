class HomeController < ApplicationController
  skip_filter :require_user, :only => :login
  respond_to :html, :json
  
  def index
    
  end
  
  def login
  end

  def stats
    respond_with(User.select('users.id, name, avatar, sum(steps) as steps').joins(:activity_days).where('date >= ?', 4.days.ago.to_date).group(:user_id))
    
  end

end
