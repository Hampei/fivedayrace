class ActivityDay < ActiveRecord::Base
  belongs_to :user
  attr_accessible :steps, :stairs
end
