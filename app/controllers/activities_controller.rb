class ActivitiesController < ApplicationController


  def index
  	friend_ids = current_user.friends.map(&:id)  # <== Extract all of the friend ids

  	@activities = Activity.where("user_id in (?)", friend_ids.push(current_user.id)).order("created_at desc").all




  end



end






