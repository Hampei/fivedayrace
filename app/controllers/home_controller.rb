class HomeController < ApplicationController
  skip_filter :require_user, :only => :login
  respond_to :html, :json

  def index
    
  end

  def login
  end

  def stats
    respond_with @stats = current_user.follows.add_steps.select('users.id, name, avatar').concat(
      User.where(id: current_user.id).add_steps.select('users.id, name, avatar')).
      sort_by{|o| 0-o.steps}
  end
end
