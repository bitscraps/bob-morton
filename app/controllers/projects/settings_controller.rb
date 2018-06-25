class Projects::SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @project = Project.find(params[:project_id])

    @users = @project.users
  end
end
