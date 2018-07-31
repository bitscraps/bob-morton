class Projects::InvitesController < ApplicationController
  before_action :authenticate_user!

  def create
    @project = Project.find(params[:project_id])

    invite = Invitation.new(invitation_params)
    invite.project = @project

    if invite.save!
      redirect_to project_settings_path(@project), notice: 'Invitation created'
    else
      redirect_to project_settings_path(@project), notice: 'Unable to create invite'
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
