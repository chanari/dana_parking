class Manager::ProfileController < Manager::BaseController

  def edit
    @profile = Profile.find_by user_id: current_user.id
  end

  def update

  end
end
